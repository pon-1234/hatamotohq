import { createStore } from 'vuex';
import createPersistedState from 'vuex-persistedstate';
import modules from './modules';

export default createStore({
  modules,
  plugins: [createPersistedState(
    {
      storage: window.sessionStorage,
      paths: ['global', 'system']
    }
  )],
  strict: process.env.NODE_ENV !== 'production'
});