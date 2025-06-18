/**
 * Vue Directives
 */

import TooltipDirective from './tooltip';

export default {
  install(Vue) {
    Vue.directive('tooltip', TooltipDirective);
    
    // Alias for backward compatibility with v-b-tooltip
    Vue.directive('b-tooltip', TooltipDirective);
  }
};

export { TooltipDirective };