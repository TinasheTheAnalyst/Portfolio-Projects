--Cleaning Data in SQL
SELECT *
FROM NashvilleHousing

--Sale Date 
SELECT DateOfSale, Convert(date,SaleDate)
FROM NashvilleHousing

UPDATE NashvilleHousing
SET SaleDate =  Convert(date,SaleDate)

ALTER Table NashvilleHousing
Add DateOfSale date;

UPDATE NashvilleHousing
SET DateOfSale =  Convert(date,SaleDate)

--Populate Property Address Data
SELECT *
FROM NashvilleHousing
--Where PropertyAddress is Null
Order By ParcelID

SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress
FROM NashvilleHousing a
JOIN NashvilleHousing b
ON a.ParcelID = b.ParcelID
AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress is Null

Update a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
FROM NashvilleHousing a
JOIN NashvilleHousing b
ON a.ParcelID = b.ParcelID
AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress is Null

SELECT [UniqueID ], ParcelID, PropertyAddress, OwnerName, DateOfSale, SalePrice
FROM NashvilleHousing

--Breaking Address into Individual Columns (Address, City, State)
SELECT
Parsename(Replace(PropertyAddress,',','.'), 2)
,Parsename(Replace(PropertyAddress,',','.'), 1)
FROM NashvilleHousing

ALTER Table NashvilleHousing
Add Address Nvarchar(255);

UPDATE NashvilleHousing
SET Address = Parsename(Replace(PropertyAddress,',','.'), 2)

ALTER Table NashvilleHousing
Add City Nvarchar(255);

UPDATE NashvilleHousing
SET City = Parsename(Replace(PropertyAddress,',','.'), 1) 

SELECT [UniqueID ], ParcelID, Address, City, OwnerName, DateOfSale, SalePrice
FROM NashvilleHousing

--Remove Duplicates

WITH RowNumCTE AS(
SELECT *,
Row_Number() OVER(
Partition  By ParcelID,
              PropertyAddress,
			  SaleDate,
			  SalePrice,
			  LegalReference,
			  OwnerName
			  Order by UniqueID
              )row_num

FROM NashvilleHousing
--Order by ParcelID
)

SELECT *
FROM RowNumCTE
WHERE row_num > 1
Order by ParcelID

--Delete Unused Columns
SELECT *
FROM NashvilleHousing

Alter Table NashvilleHousing
Drop Column SaleDate, Acreage, TaxDistrict