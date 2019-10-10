parser = require './parser'
operations = require './operations'

applyOp = (expr, ops) =>
    loop
        opIndex = expr.findIndex (char) -> Object.keys(ops).includes(char)
        if opIndex is -1 then return expr
        operation = ops[expr[opIndex]]
        left = calcExpr expr[opIndex - 1]
        right = calcExpr expr[opIndex + 1]
        expr = [
            ...expr[...opIndex - 1],
            operation(left, right),
            ...expr[opIndex + 2...]
        ]

calcExpr = (expr) =>
    if typeof expr is 'number'
        expr
    else
        operations.reduce(applyOp, expr)[0]

expressionCalculator = (expr) =>
    parsedExpr = parser.parseExpression expr
    calcExpr parsedExpr

module.exports = { expressionCalculator }
