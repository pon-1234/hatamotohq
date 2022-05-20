import StreamRouteApi from '../api/stream_route_api';

export const actions = {
  async createStreamRoute(_, query) {
    try {
      return await StreamRouteApi.create(query);
    } catch (error) {
      return error;
    }
  }
};