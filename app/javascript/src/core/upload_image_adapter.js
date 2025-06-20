import Util from '@/core/util.js';
import axios from 'axios';

export default class UploadImageAdapter {
  constructor(loader) {
    // The file loader instance to use during the upload.
    this.loader = loader;
    this.url = import.meta.env.VITE_ROOT_PATH + '/admin/announcements/upload_image';
    this.token = Util.getCsrfToken();
  }

  upload() {
    return this.loader.file
      .then(uploadedFile => {
        return new Promise((resolve, reject) => {
          const data = new FormData();
          data.append('file', uploadedFile);

          axios({
            url: this.url,
            method: 'POST',
            data,
            headers: {
              'Content-Type': 'multipart/form-data;',
              'X-CSRF-TOKEN': this.token
            },
            withCredentials: false
          }).then(response => {
            if (response.status === 200) {
              resolve({
                default: response.data.url
              });
            } else {
              reject(response.data.message);
            }
          }).catch(error => {
            reject(error);
          });
        });
      });
  }
}