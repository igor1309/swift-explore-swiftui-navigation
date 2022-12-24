//
//  asyncMap.swift
//  
//
//  Created by Igor Malyarov on 20.09.2022.
//

import Combine

#warning("add and test max paublishers")
extension Publisher {
    func asyncMap<T>(
        _ transform: @escaping (Output) async -> T
    ) -> Publishers.FlatMap<Future<T, Never>, Self> {
        flatMap { value in
            Future { promise in
                Task {
                    let output = await transform(value)
                    promise(.success(output))
                }
            }
        }
    }
    
    func asyncMap<T>(
        _ transform: @escaping (Output) async throws -> T
    ) -> Publishers.FlatMap<Future<T, Error>, Self> {
        flatMap { value in
            Future { promise in
                Task {
                    do {
                        let output = try await transform(value)
                        promise(.success(output))
                    } catch {
                        promise(.failure(error))
                    }
                }
            }
        }
    }
    
//    func asyncFlatMap<P: Publisher>(
//        _ transform: @escaping (Output) async -> P
//    ) -> AnyPublisher<P.Output, P.Failure> {//Publishers.FlatMap<P, Self> {
//        flatMap { value in
//            Future { promise in
//                Task {
//                    do {
//                        let publisher = try await transform(value)
////                        promise(.success(output))
//                    } catch {
////                        promise(.failure(error))
//                    }
//                }
//            }
//        }
//    }
}


extension Future where Failure == Error {
    convenience init(asyncFulfill: @escaping () async throws -> Output) {
        self.init { promise in
            Task {
                do {
                    let output = try await asyncFulfill()
                    promise(.success(output))
                } catch {
                    promise(.failure(error))
                }
            }
        }
    }
}

extension Future where Failure == Never {
    convenience init(asyncFulfill: @escaping () async -> Output) {
        self.init { promise in
            Task {
                let output = await asyncFulfill()
                promise(.success(output))
            }
        }
    }
}
