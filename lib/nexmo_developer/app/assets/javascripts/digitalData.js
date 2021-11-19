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

document.getElementById('signin').addEventListener('click', function() {
  updateVisitorType()
})

function updateVisitorType() {
  const { digitalData } = window
  digitalData.user.profile.profileInfo.visitorType = 'customer'
}
