USE library;

-- 1.  Show the members under the name "Jens S."
--     who were born before 1970 that became members of the library in 2013.
SELECT *
FROM tmember
WHERE cName = 'Jens S.'
  AND dBirth < '1970-01-01'
  AND dNewMember LIKE '2013%';

-- 2.   Show those books that have not been published by the publishing
--      companies with ID 15 and 32, except if they were published before 2000.
SELECT *
FROM tbook
WHERE
    NOT (nPublishingCompanyID = 15
        AND nPublishingCompanyID = 32)
   OR nPublishingYear < '2000-01-01';

-- 3.   Show the name and surname of the members who have a phone number, but no address.
SELECT cName, cSurname
FROM tmember
WHERE cPhoneNo IS NOT NULL AND cAddress IS NULL;

-- 4.   Show the authors with surname "Byatt" whose name
--      starts by an "A" (uppercase) and contains an "S" (uppercase).
SELECT *
FROM tauthor
WHERE cSurname = 'Byatt'
  AND cName LIKE 'A%'
  AND cName LIKE '%S%';

-- 5.	Show the number of books published in 2007 by the publishing company with ID 32.
SELECT COUNT(*)
FROM tbook
WHERE nPublishingYear = 2007
  AND nPublishingCompanyID = 32;

-- 6.	For each day of the year 2014,
--       show the number of books loaned by the member with CPR "0305393207";
SELECT COUNT(*)
FROM tloan
WHERE cCPR = '0305393207'
  AND dLoan LIKE '2014%';

-- 7.	    Modify the previous clause so that only those days
--          where the member was loaned more than one book appear.
SELECT dLoan
FROM tloan
WHERE cCPR = '0305393207'
  AND dLoan LIKE '2014%'
GROUP BY dLoan HAVING count(*) > 1;

-- 8.	Show all library members from the newest to the oldest. Those who became members on
--      the same day will be sorted alphabetically (by surname and name) within that day.
SELECT *
FROM tmember
ORDER BY dNewMember
DESC, cSurname,cName;

-- 9.	Show the title of all books published by the publishing company
--      with ID 32 along with their theme or themes.
SELECT cTitle, cName
FROM tbook, tbooktheme, ttheme
WHERE nPublishingCompanyID = 32
AND tbook.nBookID = tbooktheme.nBookID
AND tbooktheme.nThemeID = ttheme.nThemeID;

-- 10. Show the name and surname of every author along with the number of books authored by them,
--     but only for authors who have registered books on the database.
SELECT cName, cSurname, COUNT(tbook.cTitle)
FROM tauthor, tbook, tauthorship
WHERE tauthor.nAuthorID = tauthorship.nAuthorID
AND tauthorship.nBookID = tbook.nBookID
AND cTitle IS NOT NULL
GROUP BY cNAme;

-- 11. Show the name and surname of all the authors with published books
--     along with the lowest publishing year for their books.
SELECT cName, cSurname, MIN(nPublishingYear) AS MinimumYear
FROM tauthor, tauthorship, tbook
WHERE tauthor.nAuthorID = tauthorship.nAuthorID
AND tauthorship.nBookID = tbook.nBookID AND cTitle IS NOT  NULL
group by cName;

-- 12. For each signature and loan date, show the title of the corresponding books
--     and the name and surname of the member who had them loaned.
SELECT tloan.cSignature, dLoan, cTitle, cName, cSurname
FROM tloan, tbookcopy, tbook, tmember
WHERE tloan.cSignature = tbookcopy.cSignature
AND tbookcopy.nBookID = tbook.nBookID AND tloan.cCPR = tmember.cCPR;

--  13. Repeat exercises 9 to 12 using the modern JOIN notation.

-- 9b.	Show the title of all books published by the publishing company
--       with ID 32 along with their theme or themes.
SELECT tbook.cTitle, ttheme.cName as "Theme"
FROM tbooktheme
inner join tbook on tbooktheme.nBookID = tbook.nBookID
inner join ttheme  on tbooktheme.nThemeID = ttheme.nThemeID
WHERE tbook.nPublishingCompanyID = 32;

-- 10b. Show the name and surname of every author along with the number of books authored by them,
--     but only for authors who have registered books on the database.
SELECT tauthor.cName, tauthor.cSurname, COUNT(tbook.cTitle)
FROM tauthorship
inner join tauthor on tauthorship.nAuthorID = tauthor.nAuthorID
inner join tbook on tauthorship.nBookID = tbook.nBookID
  AND cTitle IS NOT NULL
GROUP BY cNAme;

-- 11b. Show the name and surname of all the authors with published books along with
--     the lowest publishing year for their books.
SELECT cName, cSurname, MIN(nPublishingYear) AS MinimumYear
FROM tauthorship
INNER JOIN tauthor on tauthorship.nAuthorID = tauthor.nAuthorID
INNER JOIN tbook on tauthorship.nBookID = tbook.nBookID
WHERE cTitle IS NOT  NULL
group by cName;

-- 12b. For each signature and loan date, show the title of the corresponding books
--     and the name and surname of the member who had them loaned.
SELECT tloan.cSignature, dLoan, cTitle, cName, cSurname
FROM tloan
INNER JOIN tbookcopy on tloan.cSignature = tbookcopy.cSignature
INNER JOIN tmember on tloan.cCPR = tmember.cCPR
INNER JOIN tbook on tbookcopy.nBookID = tbook.nBookID;

-- 14. Show all theme names along with the titles of their associated books.
--    All themes must appear (even if there are no books for some particular themes). Sort by theme name.
SELECT cName, cTitle
FROM ttheme, tbooktheme, tbook
WHERE ttheme.nThemeID = tbooktheme.nThemeID
  AND tbooktheme.nBookID = tbook.nBookID
ORDER BY cName;

-- 15.Show the name and surname of all members who joined the library in 2013
--    along with the title of the books they took on loan during that same year.
--    All members must be shown, even if they did not take any book on loan during 2013.
--    Sort by member surname and name.
SELECT tmember.cName, tmember.cSurname, if(dLoan LIKE '2013%', tbook.cTitle, '') AS BookRentedIn2013
FROM tmember, tbook, tbookcopy, tloan
WHERE tmember.cCPR = tloan.cCPR
  AND tloan.cSignature = tbookcopy.cSignature
  AND tbookcopy.nBookID = tbook.nBookID
  AND tmember.dNewMember LIKE '2013%'
GROUP BY cName, cSurname;
use library;
SELECT tmember.cName, tmember.cSurname, dNewMember
FROM tmember, tbook, tbookcopy, tloan
WHERE tmember.dNewMember LIKE '2013%'
GROUP BY cName, cSurname;



-- 16. Show the name and surname of all authors along with their nationality or nationalities
--    and the titles of their books. Every author must be shown,
--    even though s/he has no registered books.
--    Sort by author name and surname.

SELECT tauthor.cName, tauthor.cSurname, tcountry.cName, tbook.cTitle
FROM tauthor, tnationality, tcountry, tbook, tauthorship
WHERE tauthor.nAuthorID = tnationality.nAuthorID
  AND tnationality.nCountryID = tcountry.nCountryID
  AND tauthor.nAuthorID = tauthorship.nAuthorID
  AND tauthorship.nBookID = tbook.nBookID
ORDER BY tauthor.cName, cSurname;

-- 17. Show the title of those books which have had different editions published in both 1970 and 1989.
SELECT cTitle
FROM tbook
WHERE nPublishingYear = 1970
   OR nPublishingYear = 1989
GROUP BY cTitle
HAVING COUNT(*) > 1;

-- 18. Show the surname and name of all members who joined the library in December 2013
--    followed by the surname and name of those authors whose name is “William”.
SELECT tmember.cSurname, tmember.cName, tauthor.cSurname, tauthor.cName
FROM tmember, tauthor
WHERE dNewMember
          LIKE '2013-12%'
  AND tauthor.cName = 'William';

-- 19. Show the name and surname of the first chronological member of the library using subqueries.
SELECT tmember.cName, tmember.cName, dNewMember
from tmember
where dNewMember in (SELECT min(dNewMember) FROM tmember)
order by dNewMember;

-- 20. For each publishing year,
--    show the number of book titles published by publishing companies from countries
--    that constitute the nationality for at least three authors. Use subqueries.
SELECT COUNT(tbook.nBookID) as 'n of titles', tbook.nPublishingYear
FROM tpublishingcompany, tbook
WHERE tpublishingcompany.nPublishingCompanyID = tbook.nPublishingCompanyID
  and tpublishingcompany.nCountryID in (
    SELECT tnationality.nCountryID
    FROM tnationality,tcountry,tpublishingcompany
    WHERE tcountry.nCountryID = tnationality.nCountryID
      AND tpublishingcompany.nCountryID = tnationality.nCountryID
    GROUP BY tpublishingcompany.nCountryID
    HAVING COUNT(tnationality.nCountryID) >3
    )
GROUP BY tbook.nPublishingYear
;

-- SELECT tnationality.nCountryID, tcountry.cName
-- FROM tnationality,tcountry,tpublishingcompany
-- WHERE tcountry.nCountryID = tnationality.nCountryID
-- GROUP BY tcountry.nCountryID;


-- 21. Show the name and country of all publishing companies with the headings "Name" and "Country".
SELECT tpublishingcompany.cName as 'Name', tcountry.cName as 'Country'
FROM tpublishingcompany, tcountry
WHERE tpublishingcompany.nCountryID = tcountry.nCountryID
ORDER BY tpublishingcompany.cName;

-- 22. Show the titles of the books published between 1926 and 1978
--     that were not published by the publishing company with ID 32.

SELECT cTitle
FROM tbook
WHERE nPublishingYear BETWEEN '1926-01-01' AND '1978-01-01'
  AND NOT nPublishingCompanyID = 32;


-- 23. Show the name and surname of the members who joined the library after 2016 and have no address.

SELECT cName, cSurname
FROM tmember
WHERE dNewMember > '2016-01-01'
AND cAddress IS NULL;

-- 24. Show the country codes for countries with publishing companies. Exclude repeated values.
SELECT tpublishingcompany.nCountryID, tcountry.cName
FROM tpublishingcompany, tcountry
WHERE tpublishingcompany.nCountryID = tcountry.nCountryID
GROUP BY nCountryID;


-- 25.     Show the titles of books whose title starts by "The Tale" and that are not published by "Lynch Inc".
SELECT cTitle, tbook.nPublishingCompanyID
FROM tbook, tpublishingcompany
WHERE cTitle like 'The Tale%'
AND tbook.nPublishingCompanyID in (SELECT tpublishingcompany.nPublishingCompanyID
    FROM tpublishingcompany
    WHERE tpublishingcompany.cName NOT LIKE 'Lynch Inc'
            )
GROUP BY nBookID;

-- 26.     Show the list of themes for which the publishing company "Lynch Inc"
--        has published books, excluding repeated values.
SELECT ttheme.cName, tbook.cTitle
FROM ttheme, tpublishingcompany, tbooktheme, tbook
WHERE ttheme.nThemeID = tbooktheme.nThemeID
  AND tbooktheme.nBookID = tbook.nBookID
  AND tbook.nPublishingCompanyID = tpublishingcompany.nPublishingCompanyID
  AND tbook.nPublishingCompanyID in (SELECT tpublishingcompany.nPublishingCompanyID
                                     FROM tpublishingcompany
                                     WHERE tpublishingcompany.cName LIKE 'Lynch Inc'
);

-- 27.    Show the titles of those books which have never been loaned.
SELECT tbook.cTitle
FROM tbook
WHERE tbook.nBookID NOT IN (SELECT tbookcopy.nBookID FROM tbookcopy)
;

-- 28.   For each publishing company, show its number of existing books under the heading "No. of Books".
SELECT tpublishingcompany.cName as 'Publisher',COUNT(nBookID) as 'No. of Books'
FROM tbook,tpublishingcompany
WHERE tpublishingcompany.nPublishingCompanyID = tbook.nPublishingCompanyID
GROUP BY tbook.nPublishingCompanyID;

-- 29.    Show the number of members who took some book on a loan during 2013.
SELECT COUNT(cCPR)
FROM tloan
WHERE dLoan like '2013%';


-- 30.    For each book that has at least two authors,
--       show its title and number of authors under the heading "No. of Authors".
SELECT cTitle as 'Title', COUNT(tbook.nBookID) as 'No. of Authors'
FROM tbook,tauthorship
WHERE tbook.nBookID = tauthorship.nBookID
      AND tbook.nBookID in (SELECT nBookID
                  FROM tauthorship
                  GROUP BY nBookID
                  HAVING COUNT(*) > 1)
GROUP BY tbook.nBookID;


