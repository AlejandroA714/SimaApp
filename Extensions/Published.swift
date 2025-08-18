import Combine

extension Published.Publisher where Output: Equatable {
    /// Dispara cuando cambia el valor publicado (estilo onChange de SwiftUI).
    /// - Parameters:
    ///   - skipInitial: si true, ignora el primer valor actual.
    ///   - perform: closure con el valor nuevo.
    func onChange(
        skipInitial: Bool = true,
        perform: @escaping (Output) -> Void
    ) -> AnyCancellable {
        let upstream = skipInitial ? dropFirst().eraseToAnyPublisher() : eraseToAnyPublisher()
        return upstream
            .removeDuplicates()
            .sink(receiveValue: perform)
    }

    func onChangePair(
        emitInitialWithOldNil: Bool = true,
        perform: @escaping (_ old: Output?, _ new: Output) -> Void
    ) -> AnyCancellable {
        let base = removeDuplicates().eraseToAnyPublisher()

        let pairs = base
            .map(Optional.some) // Output -> Output?
            .scan((old: Output?.none, new: Output?.none)) { acc, newOpt in
                (old: acc.new, new: newOpt) // desplaza: old<-curr, curr<-new
            }
            .compactMap { pair -> (Output?, Output)? in
                guard let new = pair.new else { return nil }
                return (pair.old, new)
            }
            .eraseToAnyPublisher()

        let upstream: AnyPublisher<(Output?, Output), Never> =
            emitInitialWithOldNil ? pairs : pairs.dropFirst().eraseToAnyPublisher()

        return upstream.sink { old, new in perform(old, new) }
    }
}
