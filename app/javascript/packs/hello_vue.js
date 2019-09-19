import Vue from 'vue/dist/vue.esm'
import JwtGenerator from '../components/jwt_generator/JwtGenerator.vue'

document.addEventListener('DOMContentLoaded', () => {
  const app = new Vue({
    el: '#hello',
    components: { JwtGenerator }
  })
})
