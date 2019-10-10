operations = require './operations'

isOpOrBracket = (char) =>
    isOp(char) or char is ')' or char is '('

isOp = (char) => 
    operations.some (opPriorityLevel) ->
        Object
            .keys opPriorityLevel
            .includes char

chunker = (acc, val) =>
    if isOpOrBracket(val) or isOpOrBracket(acc[acc.length - 1])
        [...acc, val]
    else
        [...acc[...-1], (acc[-1..-1] or '') + val]

findMatchingBracket = (expr, startIndex) =>
    indentLevel = 0
    for item, index in expr[startIndex + 1..]
        if item is '(' then indentLevel++
        if item is ')'
            if indentLevel is 0 then return index + startIndex + 1
            indentLevel--
    throw new Error('ExpressionError: Brackets must be paired')

groupByBrackets = (expr) =>
    loop
        startIndex = expr.indexOf '('
        if startIndex is -1 then break
        matchingBracketIndex = findMatchingBracket expr, startIndex
        expr = [
            ...expr[...startIndex],
            groupByBrackets(expr[startIndex + 1...matchingBracketIndex]),
            ...expr[matchingBracketIndex + 1..]
        ]
    if expr.some (e) -> e is ')' then throw new Error('ExpressionError: Brackets must be paired') 
    expr

parseExpression = (exprString) =>
    expr = exprString
        .trim()
        .split ''
        .filter (e) -> e isnt ' '
        .reduce chunker, []
        .map (e) -> if isNaN(e) then e else parseInt(e)
    groupByBrackets expr

module.exports = { parseExpression }
