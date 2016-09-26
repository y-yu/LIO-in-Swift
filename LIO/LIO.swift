struct LIO<P, Q, A> {
    let run: () -> A
    
    init(_ r: @escaping () -> A) {
        self.run = r
    }
    
    init(_ a: A) {
        self.run = { () -> A in return a }
    }
    
    func flatMap<B, R>(_ f: @escaping (A) -> LIO<Q, R, B>) -> LIO<P, R, B> {
        return LIO<P, R, B>(f(self.run()).run())
    }
    
    func map<B>(_ f: @escaping (A) -> B) -> LIO<P, Q, B> {
        return LIO<P, Q, B>(f(self.run()))
    }
}

infix operator >>=

func >>=<P, Q, R, A, B>(_ ma: LIO<P, Q, A>, _ f: @escaping (A) -> LIO<Q, R, B>) -> LIO<P, R, B> {
    return ma.flatMap(f)
}

precedencegroup Right {
    associativity: right
}

infix operator >>>: Right

func >>><P, Q, R, A, B>(_ ma: LIO<P, Q, A>, _ mb: LIO<Q, R, B>) -> LIO<P, R, B> {
    return ma >>= { _ in return mb }
}

