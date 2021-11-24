
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
  digitalData.page.pageInfo.subCategory3 = pageName
  const subCatArray = updateSubCategories(pageName)
  digitalData.page.pageInfo.subCategory1 = subCatArray[0]
  digitalData.page.pageInfo.subCategory2 = subCatArray[1]
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

function updateSubCategories(pageName) {
  let subCategory1 = ''
  let subCategory2 = ''
  const pageNameArray = pageName.split(':')
  const categoryArray = []
  if (pageNameArray.length > 5) {
    if (pageNameArray.length === 6) {
      subCategory1 = PRIMARY_CATEGORY + ':' + pageNameArray[pageNameArray.length - 2]
      subCategory2 = subCategory1 + ':' + pageNameArray[pageNameArray.length - 1]
    } else if (pageNameArray.length === 7) {
      subCategory1 = PRIMARY_CATEGORY + ':' + pageNameArray[pageNameArray.length - 3]
      subCategory2 = subCategory1 + ':' + pageNameArray[pageNameArray.length - 2]
    }
  } else {
    subCategory2 = pageName
    subCategory1 = pageName
  }
  categoryArray.push(subCategory1)
  categoryArray.push(subCategory2)
  return categoryArray
}
