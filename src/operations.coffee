module.exports = [
    {
        '*': (left, right) -> left * right
        '/': (left, right) -> 
            if right then left / right else throw new Error('TypeError: Division by zero.')
    }, 
    {
        '+': (left, right) -> left + right
        '-': (left, right) -> left - right
    }
]