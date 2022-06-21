<template>
  <div class='Nxd-search__result'>
    <a class='Nxd-search__result__link' v-bind:href='url' target='_blank'>
      <div>
        <h6 class='Vlt-blue-dark'>{{ title }}</h6>
        <p class='Nxd-search__result__highlight' v-html='snippet'></p>
        <span class='Vlt-badge Vlt-badge--grey Nxd-search__badge' :style="colorBadge">{{ badge }}</span>
      </div>
    </a>
  </div>
</template>
<script>
export default {
  props: ['hit'],
  computed: {
    badge: function() {
      return this.hit.category.name;
    },
    colorBadge: function() {
      return this.hit.category.color ? { background: this.hit.category.color } : { background: '#757575'}
    },
    snippet: function() {
      return `...${this.hit._highlightResult.description.value}...`;
    },
    title: function() {
      return this.hit.title;
    },
    url: function() {
      return `https://developer.vonage.com/${this.hit.link}`;
    },
  }
}
</script>
