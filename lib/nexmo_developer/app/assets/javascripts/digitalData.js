// const PRIMARY_CATEGORY = 'biz:api:adp:developer'
const categorySplit = PRIMARY_CATEGORY.split(':')
const urlPath = window.location.pathname
const pageName = getPageName(urlPath)

// Updates data layer variables on every page load.
document.addEventListener('DOMContentLoaded', function() {
  const { digitalData } = window
  updatePageInfo(digitalData)
  updateSubCategories(digitalData)
})

function updatePageInfo(dataLayer) {
  dataLayer.page.pageInfo.functionDept = categorySplit.slice(0, categorySplit.length - 1).join(':')
  dataLayer.page.pageInfo.siteIdentifier = categorySplit.slice(1, categorySplit.length).join(':')
  dataLayer.page.pageInfo.lob = categorySplit[0]
  dataLayer.page.pageInfo.pageName = pageName
}

function updateSubCategories(dataLayer) {
  let subCategory1 = ''
  let subCategory2 = ''
  let subCategory3 = ''
  let pageNameArray = ''
  const urlPath = window.location.pathname
  if (urlPath == '/') {
    pageNameArray = ['homepage']
  } else {
    pageNameArray = urlPath.split('/')
  }
  const categoryResult = pageNameArray.filter(x => !x == '')
  if (categoryResult.length == 0) {
    subCategory1 = PRIMARY_CATEGORY
    subCategory2 = PRIMARY_CATEGORY
    subCategory3 = PRIMARY_CATEGORY
  } else {
    subCategory1 = PRIMARY_CATEGORY + ':' + categoryResult[0]
    subCategory2 = PRIMARY_CATEGORY + ':' + categoryResult[0]
    subCategory3 = PRIMARY_CATEGORY + ':' + categoryResult[0]
  }
  if (categoryResult[1] != undefined) {
    subCategory2 = subCategory2 + ':' + categoryResult[1]
    subCategory3 = subCategory2
  }
  if (categoryResult[2] != undefined) {
    subCategory3 = subCategory3 + ':' + categoryResult[2]
  }
  dataLayer.page.pageInfo.subCategory1 = subCategory1
  dataLayer.page.pageInfo.subCategory2 = subCategory2
  dataLayer.page.pageInfo.subCategory3 = subCategory3
}

// Click event for Sign-in button
// Changes visitorType value when clicked.
document.getElementById('signin').addEventListener('click', function() {
    updateVisitorType()
})

// Changes visitoryType to 'customer' if sign-in
// button is clicked.
// Default is null
function updateVisitorType() {
  const { digitalData } = window
  digitalData.user.profile.profileInfo.visitorType = 'customer'
}

function getPageName(urlPath) {
  let pageName = ''
  switch (urlPath) {
    case '/' :
      pageName = PRIMARY_CATEGORY + ':homepage'
      break
    default:
      pageName = PRIMARY_CATEGORY + urlPath.replaceAll('/', ':')
  }
  return pageName
}
