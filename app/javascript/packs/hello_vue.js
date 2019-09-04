import Vue from 'vue/dist/vue.esm'
import Generator from '../components/jwt_generator/generator.vue'

document.addEventListener('DOMContentLoaded', () => {
  const app = new Vue({
    el: '#hello',
    components: { Generator }
  })
})
