--What Product Category has the highest rev?
--Answer: Beverages - $99,464.50
SELECT Cat.CategoryName AS 'Category', ROUND(SUM(P.Price*OD.Quantity),2) AS 'Revenue'
FROM Categories AS 'Cat'
  JOIN Products AS 'P' ON P.CategoryID = Cat.CategoryID
  JOIN OrderDetails AS 'OD' ON OD.ProductID = P.ProductID
GROUP BY Cat.CategoryID
ORDER BY Revenue DESC;



--What Product has the highest rev in the highest Category? (your answer for #1)
--Answer: Côte de Blaye	$62,976.50
SELECT Cat.CategoryName, P.ProductName, SUM(P.Price*OD.Quantity) AS 'Revenue'
FROM Products AS 'P'
  JOIN Categories AS 'Cat' ON Cat.CategoryID = P.CategoryID
  JOIN OrderDetails AS 'OD' ON OD.ProductID = P.ProductID

WHERE Cat.CategoryID = 
  (SELECT P.CategoryID
  FROM Products AS 'P' JOIN OrderDetails AS 'OD' ON OD.ProductID = P.ProductID
  GROUP BY P.CategoryID
  ORDER BY SUM(P.Price*OD.Quantity) DESC
  LIMIT 1)

GROUP BY P.ProductID
ORDER BY Revenue DESC;



--Alternative method: Joining the subquery
SELECT PR.CategoryName, PR.ProductName, SUM(PR.Price*PR.Quantity) AS 'Revenue'
FROM
  (SELECT *
  FROM Products AS 'P'
    JOIN Categories AS 'Cat' ON Cat.CategoryID = P.CategoryID
    JOIN OrderDetails AS 'OD' ON OD.ProductID = P.ProductID) AS 'PR',

  (SELECT P.CategoryID
  FROM Products AS 'P' JOIN OrderDetails AS 'OD' ON OD.ProductID = P.ProductID
  GROUP BY P.CategoryID
  ORDER BY SUM(P.Price*OD.Quantity) DESC
  LIMIT 1) AS 'TopCat'

WHERE PR.CategoryID = TopCat.CategoryID
GROUP BY PR.ProductID
ORDER BY Revenue DESC;





--Revenue by employee in the same highest revenue product category
/*Answer: 
Margaret Peacock  $30,016.50
Robert	King      $28,598.50
Nancy	Davolio     $12,670
Steven	Buchanan  $11,872.50
Laura	Callahan    $4,214
Janet	Leverling   $4,089
Michael	Suyama    $3,247.50
Andrew	Fuller    $2,783
Anne	Dodsworth   $1,973.50
*/
SELECT Cat.CategoryName,
       Emp.FirstName,
       Emp.LastName,
       SUM(P.Price*OD.Quantity) AS 'Revenue'	 
FROM ORDERS AS 'ORD'
  JOIN Employees AS 'Emp' ON ORD.EmployeeID = Emp.EmployeeID
  JOIN OrderDetails AS 'OD' ON ORD.OrderID = OD.OrderID
  JOIN Products AS 'P' ON OD.ProductID = P.ProductID
  JOIN Categories AS 'Cat' ON Cat.CategoryID = P.CategoryID

WHERE Cat.CategoryID = 
  (SELECT P.CategoryID
  FROM Products AS 'P' JOIN OrderDetails AS 'OD' ON OD.ProductID = P.ProductID
  GROUP BY P.CategoryID
  ORDER BY SUM(P.Price*OD.Quantity) DESC
  LIMIT 1)

GROUP BY Emp.EmployeeID
ORDER BY Revenue DESC;



