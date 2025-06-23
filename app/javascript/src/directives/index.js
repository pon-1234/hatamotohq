/**
 * Vue Directives
 */

import TooltipDirective from './tooltip';
import { vClickOutside } from './click-outside';
import { vViewer } from './viewer';

export default {
  install(Vue) {
    // Vue.directive('tooltip', TooltipDirective);
    
    // Alias for backward compatibility with v-b-tooltip
    // Vue.directive('b-tooltip', TooltipDirective);
    
    // Register click-outside directive
    Vue.directive('click-outside', vClickOutside);
    
    // Register viewer directive
    Vue.directive('viewer', vViewer);
  }
};

export { TooltipDirective, vClickOutside, vViewer };