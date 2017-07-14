/* eslint no-console:0 */
// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.
//
// To reference this file, add <%= javascript_pack_tag 'application' %> to the appropriate
// layout file, like app/views/layouts/application.html.erb

import Collapsible from './Collapsible';
import Scrollspy from './Scrollspy';
import GithubCards from './GithubCards';
import TabbedExamples from './TabbedExamples';
import JsSequenceDiagrams from './JsSequenceDiagrams';
import Navigation from './Navigation';
import Scroll from './Scroll';
import Search from './Search';
import Notices from './Notices';

import {
  preventSamePage as turbolinksPreventSamePage,
  animate as turbolinksAnimate
} from './Turbolinks';

Collapsible()
Navigation()
Scroll()
turbolinksPreventSamePage()
turbolinksAnimate()

let refresh = () => {
  Notices()
  GithubCards()
  Scrollspy()
  JsSequenceDiagrams()
  $(document).foundation();
  new TabbedExamples

  if (document.getElementById('SearchComponent')) {
    ReactDOM.render(<Search/>, document.getElementById('SearchComponent'))
  }

  if(window.location.hash) {
    const anchor = document.querySelector(window.location.hash);
    if (anchor) {
      smoothScroll.animateScroll( anchor );
    }
  }
}

$(document).on('nexmo:load', function() {
  refresh()
});
