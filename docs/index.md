<h1 id="station">Station</h1>

<ol>
  <li><a href="#what-is-station">What Is Station?</a></li>
  <li><a href="#what-is-station-for">What Is Station For?</a></li>
  <li><a href="#what-problems-does-station-solve">What Problems Does Station Solve?</a></li>
  <li><a href="#how-does-station-accomplish-its-goals">How Does Station Accomplish Its Goals?</a></li>
</ol>

<h2 id="what-is-station-">What Is Station?</h2>

<p>
  Station is a platform tool. In combination with custom configuration files and a path to content files in markdown, 
  Station provides a platform website that can be used for any number of purposes.
</p>

<p>
  Station is built with Ruby on Rails as its infrastructure incorporated with Webpack. For the experienced Rails developer, 
  it will feel familiar. For a person not acquainted with Rails, it will be unnecessary to learn the nuances of the framework 
  to run or contribute content to a Station powered site.
</p>

<h2 id="what-is-station-for-">What Is Station For?</h2>

<p>
  Station is built to provide the following out of the box:
</p>

<ul>
  <li>A solution for creating text-driven content websites quickly</li>
  <li>The ability for non-software developers to contribute content in a streamlined fashion</li>
  <li>Highly customizable to meet each site&#39;s needs through a set of defined configuration files</li>
</ul>

<h2 id="what-problems-does-station-solve-">What Problems Does Station Solve?</h2>

<p>
  There are multiple concerns involved in creating a platform site, and all too often, any individual contributor needs 
  to be proficient in many of them to make a contribution in their area of expertise. A technical writer should not need 
  to know Ruby to offer documentation. A graphic designer should not need to know JavaScript to contribute a graphic design 
  for the site. Yet, in many instances, that is the case.
</p>

<p>
  Furthermore, a single business often can have multiple product lines that need multiple documentation or developer portals. 
  It can be difficult to ensure that the style guide and overall look of the business remain consistent over time across 
  different platform sites.
</p>

<p>
  Station comes to solve both of these problems. Through Station people can contribute in their area of expertise without 
  needing to be proficient in other areas. Likewise, through Station distinct product documentation portals under the same 
  business can be built and can retain sustainably the same experience across platforms.
</p>

<h2 id="how-does-station-accomplish-its-goals-">How Does Station Accomplish Its Goals?</h2>

<p>Station accomplishes this by:</p>

<ul>
  <li>Providing a CLI that lets administrators boot up a platform with a one-line command</li>
  <li>Offering different configuration files for different customizable aspects of the platform</li>
  <li>Integrating web assets such as images from the <code>/public</code> folder in the content path into the platform</li>
  <li>Utilizing custom exception messaging to provide users with advice during troubleshooting platform problems</li>
  <li>Disaggregating the code of the platform and its content so content contributors do not need to be concerned at all with the code</li>
  <li>With regular releases of new versions following semantic versioning guidelines, providing administrators with the assurance that their platform will be current with dependency upgrades by maintaining a single gem dependency, that of Station itself</li>
</ul>

<p>
  Learn more about <a href="Getting-Started.md">Getting Started</a> 
  and <a href="How-To-Use.md">How To Use</a> Station.
</p>
