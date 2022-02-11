const PRIMARY_CATEGORY = process.env.ADOBE_LAUNCH_PRIMARY_CATEGORY
const categorySplit = PRIMARY_CATEGORY.split(':')
const urlPath = window.location.pathname
const pageName = getPageName(urlPath)

const setDigitalData = () => {
  let dataLayer = {
    page: {
      pageInfo: {
        pageName: '',
        functionDept: '',
        primaryCategory: PRIMARY_CATEGORY,
        siteIdentifier: '',
        lob: '',
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
  updatePageInfo(dataLayer)
  updateSubCategories(dataLayer)
  // Click event for Sign-in button
  // Changes visitorType value when clicked.
  document.getElementById('signin').addEventListener('click', function() {
    updateVisitorType(dataLayer)
  })
  return dataLayer
}

// Changes visitoryType to 'customer' if sign-in
// button is clicked.
// Default is null
function updateVisitorType(dataLayer) {
  // const { digitalData } = window
  dataLayer.user.profile.profileInfo.visitorType = 'customer'
}

function updateSubCategories(dataLayer) {
  let subCategory1 = ''
  let subCategory2 = ''
  let subCategory3 = ''
  const urlPath = window.location.pathname
  const pageNameArray = urlPath.split('/')
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

function updatePageInfo(dataLayer) {
  dataLayer.page.pageInfo.functionDept = categorySplit.slice(0, categorySplit.length - 1).join(':')
  dataLayer.page.pageInfo.siteIdentifier = categorySplit.slice(1, categorySplit.length).join(':')
  dataLayer.page.pageInfo.lob = categorySplit[0]
  dataLayer.page.pageInfo.pageName = pageName
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

export default setDigitalData
