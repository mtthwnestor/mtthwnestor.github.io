<!-- wp:group -->
<div>
  <!-- wp:post-featured-image {"width":"128px","sizeSlug":"full","style":{"css":"text-align: center;"}} /-->
  <!-- wp:heading -->
  <h1 style="text-align: center">{{basics.name}}</h1>
  <!-- /wp:heading -->

  <!-- wp:paragraph -->
  <p style="text-align: center; margin-top: 1px"><em
    >{{basics.pronouns}}</em></p>
  <!-- /wp:paragraph -->

  <!-- wp:paragraph -->
  <p>{{basics.summary}}</p>
  <!-- /wp:paragraph -->
</div>
<!-- /wp:group -->

<!-- wp:separator -->
<hr />
<!-- /wp:separator -->

<!-- wp:group -->
<div>
  <!-- wp:heading -->
  <h2 style="text-align: center">Work Experience</h2>
  <!-- /wp:heading -->

  {{#each work}}
    <!-- wp:group -->
    <div>
      <!-- wp:group -->
      <div
        style="display: flex; flex-wrap: nowrap; justify-content: space-between; align-items: baseline"
      >
        <!-- wp:heading -->
        <h3><a href="{{this.url}}" target="_blank">{{this.name}}</a></h3>
        <!-- /wp:heading -->
        <!-- wp:paragraph -->
        <p><em>{{this.position}}</em></p>
        <!-- /wp:paragraph -->
        <!-- wp:paragraph -->
        <p>{{this.startDate}}
          -
          {{#if this.endDate}}{{this.endDate}}{{#else
            }}Current{{/else}}{{/if}}</p>
        <!-- /wp:paragraph -->
      </div>
      <!-- /wp:group -->

      {{#if this.summary}}
        <!-- wp:paragraph -->
        <p>{{this.summary}}</p>
        <!-- /wp:paragraph -->
      {{/if}}

      {{#if this.highlights}}
        <!-- wp:list -->
        <ul>
          {{#each this.highlights}}
            <!-- wp:list-item -->
            <li>{{this}}</li>
            <!-- /wp:list-item -->
          {{/each}}
        </ul>
        <!-- /wp:list -->
      {{/if}}
    </div>
    <!-- /wp:group -->
  {{/each}}
</div>
<!-- /wp:group -->

<!-- wp:separator -->
<hr />
<!-- /wp:separator -->

<!-- wp:group -->
<div>
  <!-- wp:heading -->
  <h2 style="text-align: center">Education</h2>
  <!-- /wp:heading -->

  {{#each education}}
    <!-- wp:group -->
    <div
      style="display: flex; flex-wrap: nowrap; justify-content: space-between; align-items: baseline"
    >
      <!-- wp:heading -->
      <h3><a href="{{this.url}}" target="_blank">{{this.institution}}</a></h3>
      <!-- /wp:heading -->
      <!-- wp:paragraph -->
      <p>{{this.startDate}}
        -
        {{#if this.endDate}}{{this.endDate}}{{#else}}Current{{/else}}{{/if}}</p>
      <!-- /wp:paragraph -->
    </div>
    <!-- /wp:group -->
  {{/each}}
</div>
<!-- /wp:group -->

<!-- wp:separator -->
<hr />
<!-- /wp:separator -->

<!-- wp:group -->
<div>
  <!-- wp:heading -->
  <h2 style="text-align: center">Projects</h2>
  <!-- /wp:heading -->

  {{#each projects}}
    <!-- wp:group -->
    <div>
      <!-- wp:group -->
      <div
        style="display: flex; flex-wrap: nowrap; justify-content: space-between; align-items: baseline"
      >
        <!-- wp:heading -->
        <h3><a href="{{this.url}}" target="_blank">{{this.name}}</a></h3>
        <!-- /wp:heading -->
        <!-- wp:paragraph -->
        <p><em>{{this.entity}}</em></p>
        <!-- /wp:paragraph -->
        <!-- wp:paragraph -->
        <p>{{this.startDate}}
          -
          {{#if this.endDate}}{{this.endDate}}{{#else
            }}Current{{/else}}{{/if}}</p>
        <!-- /wp:paragraph -->
      </div>
      <!-- /wp:group -->

      <!-- wp:paragraph -->
      <p>{{this.summary}}</p>
      <!-- /wp:paragraph -->

      {{#if this.highlights}}
        <!-- wp:list -->
        <ul>
          {{#each this.highlights}}
            <!-- wp:list-item -->
            <li>{{this}}</li>
            <!-- /wp:list-item -->
          {{/each}}
        </ul>
        <!-- /wp:list -->
      {{/if}}
    </div>
    <!-- /wp:group -->
  {{/each}}
</div>
<!-- /wp:group -->

<!-- wp:separator -->
<hr />
<!-- /wp:separator -->

<!-- wp:group -->
<div>
  <!-- wp:heading -->
  <h2 style="text-align: center">Certificates</h2>
  <!-- /wp:heading -->

  {{#each certificates}}
    <!-- wp:group -->
    <div
      style="display: flex; flex-wrap: nowrap; justify-content: space-between; align-items: baseline"
    >
      <!-- wp:heading -->
      <h3><a href="{{this.url}}" target="_blank">{{this.name}}</a></h3>
      <!-- /wp:heading -->
      <!-- wp:paragraph -->
      <p><em>{{this.issuer}}</em></p>
      <!-- /wp:paragraph -->
      <!-- wp:paragraph -->
      <p>{{this.date}}</p>
      <!-- /wp:paragraph -->
    </div>
    <!-- /wp:group -->
  {{/each}}
</div>
<!-- /wp:group -->

<!-- wp:separator -->
<hr />
<!-- /wp:separator -->

<!-- wp:group -->
<div>
  <!-- wp:heading -->
  <h2 style="text-align: center">Skills</h2>
  <!-- /wp:heading -->

  <!-- wp:group -->
  <div
    style="display: flex; flex-wrap: wrap; justify-content: space-between; align-items: baseline"
  >
    {{#each skills}}
      <!-- wp:group -->
      <div>
        <!-- wp:group -->
        <div>
          <!-- wp:paragraph -->
          <p><strong>{{this.name}}</strong></p>
          <!-- /wp:paragraph -->
          <!-- wp:paragraph -->
          <p style="margin-top: 1px"><em>{{this.level}}</em></p>
          <!-- /wp:paragraph -->
        </div>
        <!-- /wp:group -->

        <!-- wp:list -->
        <ul>
          {{#each this.keywords}}
            <!-- wp:list-item -->
            <li>{{this}}</li>
            <!-- /wp:list-item -->
          {{/each}}
        </ul>
        <!-- /wp:list -->
      </div>
      <!-- /wp:group -->
    {{/each}}
  </div>
</div>
<!-- /wp:group -->

<!-- wp:separator -->
<hr />
<!-- /wp:separator -->

<!-- wp:group -->
<div>
  <!-- wp:heading -->
  <h2 style="text-align: center">References</h2>
  <!-- /wp:heading -->

  {{#each references}}
    <!-- wp:group -->
    <div>
      <!-- wp:paragraph -->
      <p>{{this.reference}}</p>
      <!-- /wp:paragraph -->
      <!-- wp:paragraph -->
      <p style="margin-top: 1px">-
        {{this.name}},
        {{this.relationship}}
        at
        {{this.organization}}</p>
      <!-- /wp:paragraph -->
    </div>
    <!-- /wp:group -->
  {{/each}}
</div>
<!-- /wp:group -->