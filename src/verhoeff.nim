import algorithm, strutils

type 
    InvalidFormat = object of Exception
    InvalidCheckSum = object of Exception


let multiplication_table = [
    [0, 1, 2, 3, 4, 5, 6, 7, 8, 9],
    [1, 2, 3, 4, 0, 6, 7, 8, 9, 5],
    [2, 3, 4, 0, 1, 7, 8, 9, 5, 6],
    [3, 4, 0, 1, 2, 8, 9, 5, 6, 7],
    [4, 0, 1, 2, 3, 9, 5, 6, 7, 8],
    [5, 9, 8, 7, 6, 0, 4, 3, 2, 1],
    [6, 5, 9, 8, 7, 1, 0, 4, 3, 2],
    [7, 6, 5, 9, 8, 2, 1, 0, 4, 3],
    [8, 7, 6, 5, 9, 3, 2, 1, 0, 4],
    [9, 8, 7, 6, 5, 4, 3, 2, 1, 0]]

let permutation_table = [
    [0, 1, 2, 3, 4, 5, 6, 7, 8, 9],
    [1, 5, 7, 6, 2, 8, 3, 0, 9, 4],
    [5, 8, 0, 3, 7, 9, 6, 1, 4, 2],
    [8, 9, 1, 6, 0, 4, 3, 5, 2, 7],
    [9, 4, 5, 3, 1, 2, 6, 8, 7, 0],
    [4, 2, 8, 6, 5, 7, 3, 9, 0, 1],
    [2, 7, 9, 3, 8, 0, 6, 4, 1, 5],
    [7, 0, 4, 6, 9, 1, 3, 2, 5, 8]]

proc checksum*(number: string): int =
    let num_to_array = reversed(toOpenArray(number, 0, len(number)-1))
    var numberseq: seq[int]
    for num in num_to_array.items:
        numberseq.add(int(num))
    for i, n in numberseq:
        result = multiplication_table[result][permutation_table[i mod 8][parseInt($chr(n))]]

proc validate(number: string): string =
    var valid: bool
    if not number.len > 0:
        raise newException(InvalidFormat, "invalid format")
    try:
        valid = checksum(number) == 0
    except Exception:
        raise newException(InvalidFormat, "invalid format")
    if not valid:
        raise newException(InvalidCheckSum, "invalid checksum")
    return number
        
proc is_valid*(number: string): bool =
    try:
        return validate(number).len > 0
    except InvalidChecksum:
        return false

proc calc_check_digit*(number: string): string =
    return $multiplication_table[checksum(number & "0")].find(0)


if isMainModule:
    assert checksum("1234567890120") == 0
    assert checksum("84736430954837284567892") == 0
    assert is_valid("123451") == true
    assert is_valid("122451") == false
    assert is_valid("128451") == false
    echo is_valid("426710845")