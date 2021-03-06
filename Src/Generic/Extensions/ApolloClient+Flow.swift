//
//  ApolloClient+Flow.swift
//  Hedvig
//
//  Created by Sam Pettersson on 2018-11-29.
//  Copyright © 2018 Hedvig AB. All rights reserved.
//

import Apollo
import Flow
import Foundation
import Presentation
import UIKit

extension ApolloClient {
    func fetch<Query: GraphQLQuery>(
        query: Query,
        cachePolicy: CachePolicy = .returnCacheDataElseFetch,
        queue: DispatchQueue = DispatchQueue.main
    ) -> Future<GraphQLResult<Query.Data>> {
        return Future<GraphQLResult<Query.Data>> { completion in
            let cancellable = self.fetch(
                query: query,
                cachePolicy: cachePolicy,
                queue: queue,
                resultHandler: { [unowned self] (result: GraphQLResult<Query.Data>?, error: Error?) in
                    if result != nil {
                        completion(.success(result!))
                    } else {
                        if error?.localizedDescription == "cancelled" {
                            return
                        }
                        
                        log.error(error?.localizedDescription)

                        self.showNetworkErrorMessage { [unowned self] in
                            self.fetch(
                                query: query,
                                cachePolicy: cachePolicy,
                                queue: queue
                            ).onResult { result in
                                completion(result)
                            }
                        }
                    }
                }
            )

            return Disposer {
                cancellable.cancel()
            }
        }
    }

    func refetchOnRefresh<Query: GraphQLQuery>(
        query: Query,
        refreshControl: UIRefreshControl,
        queue: DispatchQueue = DispatchQueue.main
    ) -> Disposable {
        return refreshControl.onValue { [unowned self] _ in
            self.fetch(query: query, cachePolicy: .fetchIgnoringCacheData, queue: queue).onValue { _ in
                refreshControl.endRefreshing()
            }
        }
    }

    func perform<Mutation: GraphQLMutation>(
        mutation: Mutation,
        queue: DispatchQueue = DispatchQueue.main
    ) -> Future<GraphQLResult<Mutation.Data>> {
        return Future<GraphQLResult<Mutation.Data>> { completion in
            let cancellable = self.perform(
                mutation: mutation,
                queue: queue,
                resultHandler: { [unowned self] (result: GraphQLResult<Mutation.Data>?, error: Error?) in
                    if result != nil {
                        completion(.success(result!))
                    } else {
                        if error?.localizedDescription == "cancelled" {
                            return
                        }
                        
                        log.error(error?.localizedDescription)

                        self.showNetworkErrorMessage { [unowned self] in
                            self.perform(mutation: mutation, queue: queue).onResult { result in
                                completion(result)
                            }
                        }
                    }
                }
            )

            return Disposer {
                cancellable.cancel()
            }
        }
    }

    public func watch<Query: GraphQLQuery>(
        query: Query,
        cachePolicy: CachePolicy = .returnCacheDataElseFetch,
        queue: DispatchQueue = DispatchQueue.main
    ) -> Signal<GraphQLResult<Query.Data>> {
        return Signal { callbacker in
            let bag = DisposeBag()

            let watcher = self.watch(query: query, cachePolicy: cachePolicy, queue: queue) { result, error in
                if let result = result {
                    callbacker(result)
                } else {
                    if error?.localizedDescription == "cancelled" {
                        return
                    }
                    
                    log.error(error?.localizedDescription)

                    self.showNetworkErrorMessage { [unowned self] in
                        bag += self.watch(query: query, cachePolicy: cachePolicy, queue: queue).onValue { result in
                            callbacker(result)
                        }
                    }
                }
            }

            return Disposer {
                watcher.cancel()
                bag.dispose()
            }
        }
    }

    func subscribe<Subscription>(subscription: Subscription, queue _: DispatchQueue = DispatchQueue.main) -> Signal<GraphQLResult<Subscription.Data>> where Subscription: GraphQLSubscription {
        return Signal { callbacker in
            let bag = DisposeBag()

            let subscriber = self.subscribe(subscription: subscription, resultHandler: { result, error in
                log.error(error?.localizedDescription)
                if let result = result {
                    callbacker(result)
                }
            })

            return Disposer {
                subscriber.cancel()
                bag.dispose()
            }
        }
    }
}
