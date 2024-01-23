# SQL Notes

[TOC]

## Simple queries

Perhaps the simplest form of query in SQL asks for those tuples of some one relation that satisfy a condition. This simple query, like almost all SQL queries, uses the three keywords - SELECT, FROM, and WHERE.  

Let's assume we're working with this data base:  

![](pics/example_schemas/movies_schema.PNG)  

Here's a query that illustrates the usage of the three keywords:  

```sql
SELECT *
FROM Movies
WHERE studioName = 'Disney' AND year = 1990;
```

The FROM clause gives the relation or relations to which the query refers. The WHERE clause is a condition. Tuples must satisfy the condition in order to match the query. The SELECT clause tells which attributes of the tuples matching the condition are produced as part of the answer. The * in this example indicates that the entire tuple is produced.  

One way to interpret this query is to consider each tuple of the relation mentioned in the FROM clause. The condition in the WHERE clause is applied to the tuple. More precisely, any attributes mentioned in the WHERE clause are replaced by the value in the tuple’s component for that attribute. The condition is then evaluated, and if true, the components appearing in the SELECT clause are produced as one tuple of the answer.  

A good practise is to read and write queries in the order FROM - WHERE - SELECT.  

In place of the * of the SELECT clause, we may list some of the attributes of the relation mentioned in the FROM clause. The result will be projected onto the attributes listed:  

```sql
SELECT title, length
FROM Movies
WHERE studioName = 'Disney' AND year = 1990;
```

We can also give aliases to columns in the result by using AS in the SELECT clause:  

```sql
SELECT title AS name, length AS duration
FROM Movies
WHERE studioName = 'Disney' AND year = 1990;
```

Another option in the SELECT clause is to use an expression in place of an attribute:  

```sql
SELECT title AS name, length*0.016667 AS lengthInHours
FROM Movies
WHERE studioName = 'Disney' AND year = 1990;
```

SQL is **case insensitive** for both keywords and identifiers (such as attributes).  

### Operators

The expressions that may follow WHERE include conditional expressions. These can include:  

*  comparison operators  
  =, != (<>), <, >=
* numerical operators  
  *, +, /, -
*  boolean operators  
  AND, OR, NOT, IS NULL, IS NOT NULL
* string operators  
  For example string concatenation: `'foo' || 'bar' = 'foobar'`

### Data types

1  3.14   'string'  TRUE FALSE  

DATE 'yyyy-mm-dd'  TIME 'hh:mm:ss'  TIMESTAMP '<date> <time>'

### Strings

When two strings are compared, padding is ignored so VARCHAR and CHAR strings can be compared.  

Strings can be compared with =, !=, <, <=, >=, >, i.e. lexicographical order is used.  

Since `'` is a string literal delimiter, if a string contains it, the character is preceded by another `'`, that is: the string "SQL's rules" as a literal is: 'SQL''s rules'.  

Note that dates and times can be compared just like strings are!  

### Pattern matching

`<string> [NOT] LIKE <pattern>`  

`%` in a pattern stands for an arbitrary word, `_` stands for an arbitrary character. If we wish to match `%` or `_` themselves, we can choose whatever escape character we like, say `\`:  
`<string> LIKE '\_example\%' ESCAPE '\'`  
This would match only `'_example%'`.  

`('Dr. ' || fullName) LIKE 'Dr.%Schwarz'`  

### NULL values

SQL allows attributes to have a special value `NULL`, which is called the null value. In WHERE clauses, we must be prepared for the possibility that a component of some tuple we are examining will be `NULL`. When we operate upon a `NULL` value, we have to remember that:  

 - an arithmetic (or string) expression that involves a NULL value results in a NULL value
 - any comparison involving a NULL value results in the UNKNOWN value  
However, we must remember that NULL is NOT a constant. To check for NULLs we use: `<attribute> IS [NOT] NULL`

### The third truth-value UNKNOWN

T AND U = U, F AND U = F, U AND U = U  

T OR U = T, F OR U = U, U OR U = U  

NOT U = U

SQL conditions, as appear in WHERE clauses of select-from-where statements, apply to each tuple
in some relation, and for each tuple, one of the three truth values, TRUE, FALSE, or UNKNOWN is
produced. However, only the tuples for which the condition has the value TRUE become part of the
answer.  

### Ordering results

We can order the output of a query by adding, at the end of the query, the line:  
`ORDER BY <attributes lits> [DESC]`  

Note that the list of attributes may include attributes that are not projected. All the tuples that are going to be part of the result are first sorted and then passed to the SELECT clause.  

Another useful feature is that we can use arithmetic/string expressions in the attribute list, that is, expressions like this: `<A1>+<A2>, <A3>||<A4>` (sort on the sum of A1 and A2 and on the concatenation of A3 and A4)  

`... ORDER BY YEAR(CURRENT_DATE) - YEAR(BIRTHDATE)`

```sql
SELECT title, length
FROM Movies
WHERE studioName = 'Disney' AND year = 1990
ORDER BY title;
```

## Queries involving more than one realtion

We are **free to** prefix any attribute name in a query by the relation name and a dot: `<R>.<A>`. Whenever two relations are a part of a query and have matching attribute names, we **have to** prefix these attribute names with their corresponding relation name and a dot.  

However, sometimes we need to ask a query that involves two or more tuples from the same relation. We may list a relation R as many times as we need to in the FROM clause, but we need a way to refer to each occurrence of R. SQL allows us to deﬁne, for each occurrence of R in the FROM clause, an alias. Each use of R in the FROM clause is followed by the (optional) keyword AS and the alias.

### Set operations

`(<subquery 1>) OPERATION [ALL] (<subquery 2>)`;  

OPERATION is one of UNION, INTERSECT or EXCEPT. When ALL is used, the operation is on multisets, otherwise
it is a set operation.  

The relations that result from the subqueries must have the same **list** of attribute names an types. That is, they must have the same attributes, they should be ordered in the same way and have the same types.  If we want to use a stored relation R as an operand to a set operation, we can use the subquery  `(SELECT * FROM R)` to do so.  

### Subqueries

A query that is part of another is called a subquery. Set operations in SQL are an example where subqueries are used since UNION, INTERSECT and EXCEPT expect subqueires as arguments. Three of the most common uses of subqueries are:

 - subqueries that return a scalar value  
   This value can then be compared with another value or an attribute in a WHERE clause
   
 - subqueries that return relations  
   These relations can then be used in different ways in WHERE clauses:  
   
   * check whether that relation has any tuples
   * check if a tuple made from components in another relation equals any or all tuples in that relation and others
   
   If the relation resulting from the subquery has only one attribute, we can think of the relation as a list of scalar values
   
 - subqueries that appear in FROM clauses, followed by an alias that represents the tuples in the result of the subquery

### Subqueries that Produce Scalar Values

An atomic value that can appear as one component of a tuple is referred to as a scalar. A subquery that results in a unary relation (having one attribute) may have any number of tuples. We might deduce from some information we have that there will be only a single value produced for the only attribute of the relation. If so, we can use this subquery expression as if it were a constant. In particular, it may appear in a WHERE clause any place we would expect a scalar value, i.e. a constant or an attribute representing a component of a tuple. If the number of tuples produced by the subquery is not 1, then a run-time error occurs.  

### Conditions involving relations

There are a number of SQL operators that we can apply to a relation R and produce a boolean result. However, the relation R must be expressed as a subquery. As a consequence, if we want to apply these operators to a stored table *Foo*, we can use the subquery `(SELECT * FROM Foo)`, the same thing we use for set operations.  

 1) `[NOT] IN`
    
      * `<attribute> [NOT] IN (<subquery>)` - checks whether the component of a tuple corresponding to `<attribute>` matches any value in the **only** column of the result of the subquery  
      
      * `(<a 1>, ..., <a k>) [NOT] IN (<subquery>)` - checks whether the tuple formed from the components corresponding to the mentioned attributes, equals any tuple in the result of the subquery. Note that the subquery must result in a relation with k attributes
      
 2) `ALL, ANY`
    
    * `[NOT] <attribute> < ALL(<subquery>)` - checks whether the component corresponding to `<attribute>` is < than all values in the **only** column of the result of the subquery. < can be replaced by any appropriate comparison operator
    * `[NOT] (<a1>, ..., <a k>) < ANY(<subquery>)` - checks whether the tuple formed by the components corresponding to the mentioned attributes is < than at least one tuple from the result of the subquery, which must have k attributes. < can again be replaced by another comparison operator
    
 4) `[NOT] EXISTS (<subquery>)` - checks whether the result of the subquery has any tuples

A tuple in SQL is represented by a parenthesized list of scalar values (constants, attribute names, attribute expressions). For example: `(name, 40564, age, 'Calculous', score - 2)`.  

If a tuple *t* has the same number of components as a relation *R*, then it makes sense to compare *t* to tuples in *R* the way we showed in the above expressions. Note that when comparing a tuple with members of a relation *R*, we compare components using the assumed standard order for the attributes of *R*.  

Nested subqueries can often be replaced by joins as we'll see.  

### Correlated Subqueries

The simplest subqueries can be evaluated once and for all, and the result used in a higher-level query. A more complicated use of nested subqueries requires the subquery to be evaluated many times, once for each assignment of a value to some term in the subquery that comes from a tuple variable outside the subquery. A subquery of this type is called a **correlated subquery**. Put simpler, a subquery that references attributes of relations from outer queries is a correlated subquery. Since it refers to a component for an outer relation attribute, the correlated subquery will be evaluated for each value of the refered attribute.  

```sql
# Movies with sequels
SELECT title
FROM Movie AS OldMovie
WHERE year < ANY (SELECT year
                  FROM Movie
                  WHERE title = OldMovie.title);
```

When writing a correlated query it is important that we be aware of the scoping rules for names. The attribute referred to by a name in a subquery is first looked up in the relations from that subquery, if not found, the search continues in the outer subquery and so on. If an outer query has an attribute with a matching name of an attribute in the current query, we can refer to it by prefixing the attribute name with the name of the relation it belongs to and a dot, just like we did with
`OldMovie.title`.  

Another use for subqueries is as relations in a FROM clause. In a FROM list, instead of a stored relation, we may use a parenthesized subquery. Since we don’t have a name for the result of this subquery, we **must** give it an alias. We then refer to tuples in the result of the subquery as we would to tuples in any relation that appears in the FROM list.  

### Duplicate elimination

SQL uses relations that are bags (multisets) rather than sets, and a tuple can appear more than once in a relation. When an SQL query creates a new relation, the SQL system does not ordinarily eliminate duplicates. To eliminate duplicates (from a query result) we just follow the SELECT keyword with DISTINCT.  

```sql
# Unique movie names
SELECT DISTINCT title
FROM Movie;
```

It is very expensive to eliminate duplicates from a relation, so duplicate elimination should be used only when really necessary. Note that set operations normally eliminate duplicates (unless `ALL` is specified). That is, bags are converted to sets, and the set version of the operation is applied.  


## Indexing

Imagine that we want to find a piece of information that is within a large database. Let's say we are searching movies by title.  

```sql
SELECT * from Movies where title = 'Titanic';
```

Scanning the entire table is inefficient as this involves going through each record in the table in turn and applying the search condition (`title = 'Titanic'`).  

If the records in the *Movies* table were ordered alphabetically by title, we would know that the Titanic record would be somewhere near the end and would avoid scanning most records. This would make our query much more
efficient.  

This is the idea behind indexing. We know which attributes we would search by most of the time and that's why we create an index for them. An index is a data structure that includes the values of the selected attributes
(for the index) and "references" to their corresponding records in the database. The index entries are sorted and can be searched in a much faster way (binary search).  

When searching by using an index, we can do a fast search on the index, applying the search condition on. Those index entries that match our search condition are used by following their references and retrieving the corresponding records from the database.  

### Clustered indexes

A clustered index is the unique index per table that uses the primary key to organize the data that is within the table. The clustered index ensures that the primary key is stored in increasing order, which is also the order the table holds in memory. Clustered indexes are created when the table is created.  

![](pics/clustered_index.PNG)  

When searching the table by "id", the ascending order of the column allows for optimal searches to be performed.  

However, in order to search for the "name" or "city" in the table, we would have to look at every entry because these columns do not have an index.  

### Non-clustered indexes

This is where non-clustered indexes become very useful. Non-clustered indexes have entries for attributes other than the primary key, ones we typically use to search the table. These indexes can be created after a table has been created and filled.  

![](pics/non_clustered_index.PNG)  

### Index cost
Indexes improve search times but do they have a cost? When data is written to the table, the clustered index is updated first and then all other indexes of that table are updated. Every time a write is made to the database, the indexes are unusable until they have updated.  








## Joining relations

The result of joins can stand as a query by itself. Alternatively, all these expressions, since they produce
relations, may be used as subqueries in a FROM clause. These expressions are principally shorthands for more
complex select-from-where queries.

Results of all joins that are not natural joins include all the attributes of the two argument relations,
including attributes with the same name. To disambiguate references to such attributes, we have to prefix
the references with the relation name and a dot. When a relation is used more than once in a join we have
to give aliases to each occurrance of that realtion.

1) Cross join <=> cartesian product
   <R> CROSS JOIN <S>
   If it is a subquery it is equivalent to: <R>, <S>
   The latter version is much more expressive for more than two relations.

2) Theta join
   <R> JOIN <S>
   ON <condition>

   cross join followed by selection

3) Natural join
   <R> NATURAL JOIN <S>

   The join condition is that all pairs of attributes from the two relations having a common name are equated,
   and there are no other conditions. One of each pair of equated attributes is projected out.

4) Outer joins
    The outerjoin operator is a way to augment the result of a join by the dangling tuples - padded with null
    values.

  SQL refers to the standard outerjoin, which pads dangling tuples from both of its arguments, as a full
  outerjoin. A left outerjoin pads the values for the attributes of the left relation; similarly, a right
  outerjoin pads the values of the right relation.

  <R> NATURAL <<T>> OUTER JOIN <S>   (1)
  <R> <<T>> OUTER JOIN <S> ON <condition>   (2)
  where <<T>> e {FULL, LEFT, RIGHT}

  (2):
   - left means cartesion product and then:
     -- if condition is satisfied for a tuple t, take it
     -- otherwise pad the left attributes
   - right is same as left but padding is on the right attributes
   - full is cartesian product and then pad the attributes of the tuple which caused the failure
     (like presence of null values)

    (1) is (2) but the condition is omitted as it is natural

  Note, for MySQL:
   A LEFT JOIN B ON CONDITION, pads B
   A RIGHT JOIN B ON CONDITION, pads A







## Grouping and aggregation

SQL provides all the capability of the γ operator through the use of aggregation operators in SELECT
clauses and a special GROUP BY clause.

Aggregation operators in SQL: SUM, AVG, VAR, STDEV, MAX, MIN, COUNT
These operators are applied in a SELECT clause to a scalar-valued expression, typically a column name.
One exception is the expression COUNT(*), which counts all the tuples in the relation that is
constructed from the FROM clause and WHERE clause of the query.

We can use an aggregation operator A only for distinct values (components): A(DISTINCT <expression>)
If DISTINCT is omitted, A is applied to all values.
example: COUNT(DISTINCT name), SUM(age)

To group tuples, we use a GROUP BY clause, following the WHERE clause. The keywords GROUP BY are
followed by a list of grouping attributes: GROUP BY <a1>, <a2>, ..., <a k>
Tuples from the relation resulting from the FROM and WHERE clauses are grouped according to their
values for the grouping attributes, each group gives a single tuple in the result. What that tuple
consist of depends on the SELECT clause. When grouping is used, only aggretion operators (applied to an
attribute expression) and grouping attributes may be specified in the SELECT clause, aggregation
operators are applied within each group (the reason for this is simple: each group should result in a
single tuple. The grouping attributes of a group have columns consisting of the same value, this value
may be part of the result. The aggregation operators are applied to a column and return a single value.)

What happens when NULL gets involved?
 - The value NULL is ignored in any aggregation except COUNT(*) which always counts the number of tuples
   in the relation. Note that COUNT(A) is the number of tuples with non-NULL values for attribute A.
 - When the number of non-NULL values to which an aggregate operator is applied is 0, the result is NULL.
   The only exception is COUNT which returns 0.
 - NULL is treated like an ordinary value in grouping, that is, it is used for forming groups.

We can filter tuples prior to grouping with the WHERE clause, but sometimes we need to filter groups.
To do that we follow the GROUP BY clause with a HAVING clause. It consists of the keyword HAVING followed
by a condition about groups. Just like SELECT clauses, only grouping attributes and aggregation operators
applied to attribute expressions are allowed in a HAVING clause. Aggregation applies within each group.

When ORDER BY is used with grouping, only attributes of the result can be used in the ORDER BY clause.
That is the case because groups first have to be converted to tuples and only then can they be sorted.

(5) SELECT
(1) FROM
(2) WHERE
(3) GROUP BY
(4) HAVING
(6) ORDER BY

Note that if the GROUP BY clause is omitted, the whole relation forms a single group.

Functions:
 - aggregators: SUM, AVG, MIN, MAX, COUNT, STDEV, VAR
 - COALESCE(val1, val2, ...., val_n) -> first non-null value in the list
 - CURRENT_DATE, YEAR(CURRENT_DATE), MONTH(CURRENT_DATE), DAY(CURRENT_DATE) -> number
 - NVL(val1, val2) -> val1 if (val1 is not null) else val2
 - NULLIF(val1, val2) -> null if (val1 = val2) else val1
 - int_expr1 / int_expr2 -> int;
 - DECIMAL(floating_expr, num_digits, precision)
   most of the time 9 digits, 2 after the d.p. - DECIMAL(length / 60.0, 9, 2)
 - ROUND(floating_expr) -> rounded !double!
 - LENGTH(str_expr), UPPER(str_expr), LOWER(str_expr)
 - SUBSTR(str_expr, start, char_count); SUBSTR(name, 1, 3) = "Dr."
 - CONCAT(str_expr1,..., str_exprN) -> concats str values
 - REPLACE(string, old_string, new_string)
 - TRIM(str_expr) -> whitespaces from ends of str
 - TRIM('-| ', ' - hello| ') -> 'hello'
