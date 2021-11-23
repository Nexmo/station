
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
