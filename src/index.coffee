operations = [
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

isOp = (char) => 
    operations.some (opPriorityLevel) ->
        Object
            .keys opPriorityLevel
            .includes char

chunker = (acc, val) =>
    if isOp(val) or isOp(acc[acc.length - 1])
        [...acc, val]
    else
        [...acc[...-1], (acc[-1..-1] or '') + val]

parseExpression = (exprString) =>
    exprString
        .trim()
        .split ''
        .filter (e) -> e isnt ' '
        .reduce chunker, []
        .map (e) -> if isNaN(e) then e else parseInt(e)

applyOp = (expr, ops) =>
    loop
        opIndex = expr.findIndex (char) -> Object.keys(ops).includes(char)
        if opIndex is -1 then return
        operation = ops[expr[opIndex]]
        left = expr[opIndex - 1]
        right = expr[opIndex + 1]
        expr.splice(opIndex - 1, 3, operation(left, right))

expressionCalculator = (expr) =>
    parsedExpr = parseExpression expr
    operations.forEach (opGroup) ->
        applyOp parsedExpr, opGroup
    parsedExpr[0]

module.exports = { expressionCalculator }


expressionCalculator(' 49 * 63 / 58 * 36 ')