
const PRIMARY_CATEGORY = 'biz:api:adp:developer'

window.digitalData = {
  page: {
    pageInfo: {
      pageName: '',
      functionDept: 'biz:api:adp',
      primaryCategory: 'biz:api:adp:developer',
      siteIdentifier: 'api:adp:developer',
      lob: 'biz',
      subCategory1: '',
      subCategory2: '',
      subCategory3: '',
      appVersion: '',
      language: '',
      country: '',
      pageCategory: '',
      flowName: '',
      tokenFLag: '',
      spaFlag: ''
    },
    content: {
      author: '',
      businessSize: '',
      category: '',
      company: '',
      industry: '',
      name: '',
      product: '',
      profRole: '',
      publishDate: '',
      subCategory: '',
      topic: '',
      type: ''
    }
  },
  eventData: {
    events: '',
    fCTA: '',
    fIndustry: '',
    fLines: '',
    fName: '',
    interactionType: '',
    linesSlider: ''
  },
  user: {
    profile: {
      profileInfo: {
        visitorType: '',
        accountNumber: '',
        accountStatus: '',
        userType: '',
        userName: '',
        accountPlan: '',
        UserID: '',
        responsiveSiteVersion: '',
        country: '',
        acctnumLocations: '',
        acctcontractFlag: ''
      }
    }
  },
  transaction: [
    {
      productInfo: {
        productID: ''
      },
      quantity: '',
      price: {
        basePrice: ''
      }
    }
  ]
}

// Updates data layer variables on every page load.
document.addEventListener('DOMContentLoaded', function() {
  const urlPath = window.location.pathname
  const pageName = getPageName(urlPath)
  const { digitalData } = window
  digitalData.page.pageInfo.pageName = pageName
  const subCatArray = updateSubCategories(pageName, digitalData)
  digitalData.page.pageInfo.subCategory1 = subCatArray[0]
  digitalData.page.pageInfo.subCategory2 = subCatArray[1]
  digitalData.page.pageInfo.subCategory3 = subCatArray[2]
})

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

function updateSubCategories(pageName, digitalData) {
  let subCategory1 = ''
  let subCategory2 = ''
  let subCategory3 = ''
  const primaryCategoryArray = PRIMARY_CATEGORY.split(':')
  const pageNameArray = pageName.split(':')
  const categoryArray = []
  const categoryResult = pageNameArray.filter(x => !primaryCategoryArray.includes(x))
  subCategory1 = PRIMARY_CATEGORY + ':' + categoryResult[0]
  subCategory2 = PRIMARY_CATEGORY + ':' + categoryResult[0]
  subCategory3 = PRIMARY_CATEGORY + ':' + categoryResult[0]
  if (categoryResult[1] != undefined) {
    subCategory2 = subCategory2 + ':' + categoryResult[1]
    subCategory3 = subCategory2
  }
  if (categoryResult[2] != undefined) {
    subCategory3 = subCategory3 + ':' + categoryResult[2]
  }
  categoryArray.push(subCategory1)
  categoryArray.push(subCategory2)
  categoryArray.push(subCategory3)
  return categoryArray
}
