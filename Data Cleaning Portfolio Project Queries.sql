/*


Cleaning Data in SQL Queries


*/




select * from PortfolioProject.dbo.NashvilleHousing



------------------------------------------------------------------------------------

--Standardize date format

select SaleDateConverted, CONVERT(Date, SaleDate)
from PortfolioProject.dbo.NashvilleHousing

UPDATE NashvilleHousing
SET SaleDate = CONVERT(Date, SaleDate)

ALTER TABLE NashvilleHousing
Add SaleDateConverted  Date;

UPDATE NashvilleHousing
SET SaleDateConverted = CONVERT(Date, SaleDate)



------------------------------------------------------------------------------

--Populate Property Address Data

select * 
from PortfolioProject.dbo.NashvilleHousing
where propertyAddress is Null
--Order by ParcelID

select  a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
from PortfolioProject.dbo.NashvilleHousing a
JOIN PortfolioProject.dbo.NashvilleHousing b
ON a.ParcelID = b.ParcelID
AND a.[uniqueID] <> b.[uniqueID]
where a.PropertyAddress is Null

UPDATE a
SET PropertyAddress =  ISNULL(a.PropertyAddress, b.PropertyAddress)
from PortfolioProject.dbo.NashvilleHousing a
JOIN PortfolioProject.dbo.NashvilleHousing b
ON a.ParcelID = b.ParcelID
AND a.[uniqueID] <> b.[uniqueID]
where a.PropertyAddress is Null



--------------------------------------------------------------------------------

--Breaking out Address into Individual Columns(Address, City, State)

select *
from PortfolioProject.dbo.NashvilleHousing
--where PropertyAddress is NULL
--order by ParcelID

Select
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress)+1, LEN(PropertyAddress)) as Address
from PortfolioProject.dbo.NashvilleHousing

ALTER TABLE NashvilleHousing
Add PropertySplitAddress  Nvarchar(255);

UPDATE NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1)

ALTER TABLE NashvilleHousing
Add PropertySplitCity  Nvarchar(255);

UPDATE NashvilleHousing
SET PropertySplitCity =  SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress)+1, LEN(PropertyAddress))


Select
PARSENAME(REPLACE(OwnerAddress, ',', '.'),3)
,PARSENAME(REPLACE(OwnerAddress, ',', '.'),2)
,PARSENAME(REPLACE(OwnerAddress, ',', '.'),1)
from PortfolioProject.dbo.NashvilleHousing

ALTER TABLE NashvilleHousing
Add OwnerSplitAddress  Nvarchar(255);

UPDATE NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.'),3)

ALTER TABLE NashvilleHousing
Add OwnerSplitCity  Nvarchar(255);

UPDATE NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.'),2)

ALTER TABLE NashvilleHousing
Add OwnerSplitState  Nvarchar(255);

UPDATE NashvilleHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.'),1)



------------------------------------------------------------------------------------

--Change Y and N to Yes and No in "SoldAsVacant" field

Select Distinct(SoldAsVacant), Count(SoldAsVacant)
from PortfolioProject.dbo.NashvilleHousing
Group by SoldAsVacant
Order by 2

Select SoldAsVacant,
 CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
      WHEN SoldAsVacant = 'N' THEN 'No'
      ELSE  SoldAsVacant
      End
  from PortfolioProject.dbo.NashvilleHousing

  UPDATE NashvilleHousing
  SET SoldAsVacant = CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
      WHEN SoldAsVacant = 'N' THEN 'No'
      ELSE  SoldAsVacant
      End
  from PortfolioProject.dbo.NashvilleHousing



  ----------------------------------------------------------------------------------

--Remove Duplicates

WITH RowNumCTE As(
Select *, 
        ROW_NUMBER() OVER (
		PARTITION BY parcelID,
		             PropertyAddress,
					 SaleDate,
					 SalePrice,
					 LegalReference
					 Order by  UniqueID
							) row_num
from PortfolioProject.dbo.NashvilleHousing
--Order by ParcelID
)
Select *
From RowNumCTE
where row_num > 1 
--Order by PropertyAddress



-----------------------------------------------------------------------------

--Delete Unused Columns

select *
from PortfolioProject.dbo.NashvilleHousing

ALTER TABLE PortfolioProject.dbo.NashvilleHousing
DROP Column OwnerAddress, TaxDistrict, PropertyAddress

ALTER TABLE PortfolioProject.dbo.NashvilleHousing
DROP Column SaleDate

-------------------------------------------------------------------------------------