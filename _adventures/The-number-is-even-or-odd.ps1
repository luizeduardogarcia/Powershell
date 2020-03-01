# Some simple testes used
# Using the result of a module (%) operation to determine if the number is even or odd

$number = 3
$number % 2
# it will return 1

$number = 2
$number % 2
# it will return 0

# works in with IF statement, presuming the results as boolean

$number = 2
if ($number % 2) { 'odd' } else { 'even' }
# it will return 'even'

$number = 7
if ($number % 2) { 'odd' } else { 'even' }
# it will return 'odd'
