/* eslint no-console:0 */
// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.
//
// To reference this file, add <%= javascript_pack_tag 'application' %> to the appropriate
// layout file, like app/views/layouts/application.html.erb

import '@vonagevolta/volta2/js/addons/prism'

import Rails from "@rails/ujs"

import '../stylesheets/application'

require.context('../images', true);
require.context('../fonts', true);

require.context('@vonagevolta/volta2/images/logos', true)
require.context('@vonagevolta/volta2/dist/symbol', true)

require('chartkick/chart.js');
require('jquery');
require('clipboard');
require('underscore');
require('@googlemaps/google-maps-services-js');

// XXX: hack for Volta, unfortunately it doesn't provide modules :(
import Volta from "../javascript/volta/volta.js"

import Vue from 'vue'
import mermaid from 'mermaid'
import Glide, { Autoplay, Breakpoints, Controls } from '@glidejs/glide/dist/glide.modular.esm'

import { TweenLite, CSSPlugin } from 'gsap'
import GithubCards from '../javascript/github_cards'
import VoltaTabbedExamples from '../javascript/volta_tabbed_examples'
import Format from '../javascript/format'
import Scroll from '../javascript/scroll'
import Notices from '../javascript/notices'
import Feedback from '../javascript/components/feedback/Feedback.vue'
import JwtGenerator from '../javascript/components/jwt_generator/JwtGenerator.vue'
import Search from '../javascript/components/search/Search.vue'
import Concatenation from '../javascript/components/concatenation/Concatenation.vue'
import APIStatus from '../javascript/api_status'
import CodeSnippetEvents from '../javascript/code_snippet_events'
import Sidenav from '../javascript/sidenav/index'
import Topnav from '../javascript/topnav/index'
import Careers from '../javascript/careers'
import LocaleSwitcher from '../javascript/locale_switcher'
import dataLayer from '../javascript/adobe_analytics/index'

$(document).ready(function() {
  Rails.start()
  Scroll()
  Notices()
  GithubCards()
  new VoltaTabbedExamples
  new Format
  APIStatus()
  CodeSnippetEvents()
  new Sidenav()
  new Careers
  new LocaleSwitcher
  new Topnav

  // Data layer variable is assigned to window.digitalData
  // for adobe launch script to pick it up
  const values = dataLayer()
  window.digitalData = values

  if (document.getElementById('jwt-generator-app')) {
    new Vue({
      el: '#jwt-generator-app',
      template: '<JwtGenerator/>',
      components: { JwtGenerator }
    })
  }

  if (document.getElementById('search-app')) {
    new Vue({
      el: '#search-app',
      template: '<Search/>',
      components: { Search }
    })
  }

  if (document.getElementById('feedback-app')) {
    new Vue({
      el: '#feedback-app',
      template: '<Feedback/>',
      render: createElement => {
        return createElement(Feedback, { props: window.feedbackProps });
      }
    })
  }

  if (document.getElementById('concatenation-app')) {
    new Vue({
      el: '#concatenation-app',
      template: '<Concatenation/>',
      components: { Concatenation }
    })
  }

  Volta.init(['accordion', 'tooltip', 'tab', 'modal', 'dropdown'])

  setTimeout(function() {
    const sidebarActive = document.querySelector('.Vlt-sidemenu__link_active')
    if (sidebarActive){
      sidebarActive.scrollIntoView(true);
    }

    document.getElementById('header').focus();
  }, 100);

  // If there are any links in the sidebar, we need to be able to click them
  // and not trigger the Volta accordion
  $(".Vlt-sidemenu__trigger a").click(function(){
    window.location = $(this).attr("href");
    return false;
  });

  // Track A/B testing clicks
  $("[data-ab]").click(function(e) {
    let r =  new Request('/usage/ab_result', {
        method: 'POST',
        credentials: 'same-origin',
        body: JSON.stringify({'t': $(this).data('ab')}),
        headers: {
            'Content-Type': 'application/json'
        }
    });

    fetch(r).then((response) => {
        if (response.ok) { return response.json() }
        return Promise.reject({ message: 'Bad response from server', response })
    });
  });

  // Mermaid diagrams
  mermaid.initialize({
      startOnLoad:true,
      sequence: {
          useMaxWidth: false,
      },
      themeCSS: '.actor { fill: #BDD5EA; stroke: #81B1DB; }',
      htmlLabels: true
  });

  if (document.querySelector('.glide')) {
    document.querySelectorAll('.glide pre').forEach((elem) => {
      //disable copy-to-clipboard for code-snippets in hero
      elem.classList.add('Vlt-prism--copy-disabled')
    })

    const slider = new Glide('.glide').mount({ Autoplay, Breakpoints, Controls });

    // Unfortunately, Autoplay doesn't work so we got to trigger it manually.
    setInterval(() => {
      if (!document.querySelector('.glide').matches(':hover')) {
        slider.go('>');
      }
    }, 8000);
  }
});
