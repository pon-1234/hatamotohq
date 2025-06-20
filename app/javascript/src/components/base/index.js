// Base Components Export
export { default as BaseModal } from './BaseModal.vue';
export { default as BaseTable } from './BaseTable.vue';
export { default as BaseForm } from './BaseForm.vue';
export { default as BaseCard } from './BaseCard.vue';
export { default as BaseDropdown } from './BaseDropdown.vue';
export { default as BaseDropdownItem } from './BaseDropdownItem.vue';
export { default as BaseTabs } from './BaseTabs.vue';
export { default as BaseTabsSlot } from './BaseTabsSlot.vue';
export { default as BaseTab } from './BaseTab.vue';
export { default as BaseSpinner } from './BaseSpinner.vue';
export { default as BasePagination } from './BasePagination.vue';
export { default as BaseFormTags } from './BaseFormTags.vue';

// Install function for Vue.use()
export default {
  install(Vue) {
    Vue.component('BaseModal', () => import('./BaseModal.vue'));
    Vue.component('BaseTable', () => import('./BaseTable.vue'));
    Vue.component('BaseForm', () => import('./BaseForm.vue'));
    Vue.component('BaseCard', () => import('./BaseCard.vue'));
    Vue.component('BaseDropdown', () => import('./BaseDropdown.vue'));
    Vue.component('BaseDropdownItem', () => import('./BaseDropdownItem.vue'));
    Vue.component('BaseTabs', () => import('./BaseTabs.vue'));
    Vue.component('BaseTabsSlot', () => import('./BaseTabsSlot.vue'));
    Vue.component('BaseTab', () => import('./BaseTab.vue'));
    Vue.component('BaseSpinner', () => import('./BaseSpinner.vue'));
    Vue.component('BasePagination', () => import('./BasePagination.vue'));
    Vue.component('BaseFormTags', () => import('./BaseFormTags.vue'));
    
    // Aliases for backward compatibility
    Vue.component('BModal', () => import('./BaseModal.vue'));
    Vue.component('BTable', () => import('./BaseTable.vue'));
    Vue.component('BForm', () => import('./BaseForm.vue'));
    Vue.component('BCard', () => import('./BaseCard.vue'));
    Vue.component('BDropdown', () => import('./BaseDropdown.vue'));
    Vue.component('BDropdownItem', () => import('./BaseDropdownItem.vue'));
    Vue.component('BTabs', () => import('./BaseTabsSlot.vue'));
    Vue.component('BTab', () => import('./BaseTab.vue'));
    Vue.component('BSpinner', () => import('./BaseSpinner.vue'));
    Vue.component('BPagination', () => import('./BasePagination.vue'));
    Vue.component('BFormTags', () => import('./BaseFormTags.vue'));
  }
};