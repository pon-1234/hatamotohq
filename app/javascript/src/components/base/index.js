// Base Components Export
export { default as BaseModal } from './BaseModal.vue';
export { default as BaseTable } from './BaseTable.vue';
export { default as BaseForm } from './BaseForm.vue';
export { default as BaseCard } from './BaseCard.vue';

// Install function for Vue.use()
export default {
  install(Vue) {
    Vue.component('BaseModal', () => import('./BaseModal.vue'));
    Vue.component('BaseTable', () => import('./BaseTable.vue'));
    Vue.component('BaseForm', () => import('./BaseForm.vue'));
    Vue.component('BaseCard', () => import('./BaseCard.vue'));
  }
};