import Foundation

func lock() -> LIO<Unlock, Lock, Void> {
    return LIO()
}

func unlock() -> LIO<Lock, Unlock, Void> {
    return LIO()
}

func put(_ str: String) -> LIO<Lock, Lock, Void> {
    return LIO(print(str))
}

func get() -> LIO<Lock, Lock, String> {
    return LIO(readLine()!)
}

let a = lock().flatMap { _ in
        put("piyo").flatMap { _ in
        put("mofu").flatMap { _ in
        get().flatMap { input in
        put(input).flatMap { _ in
        unlock().map { _ in return }}}}}}

let _ = a.run()

print("----------------------")

let b = lock() >>= { _ in
        put("piyo") >>= { _ in
        put("mofu") >>= { _ in
        get() >>= { input in
        put(input) >>= { _ in
        unlock().map { _ in return }}}}}}

let _ = b.run()

print("----------------------")

let c = lock() >>>
        put("piyo") >>>
        put("mofu") >>>
        get() >>= { input in
            put(input) >>> unlock()
        }

let _ = c.run()
