import {
  UploadMaxSize,
  ImageType,
  VideoType,
  AudioType,
  PdfType,
  MessageType,
  ImageMimeBytes,
  VideoMimeBytes,
  AudioMimeBytes,
  PdfMimeBytes
} from './constant';
import moment from 'moment';

class Media {
  static getMaxSizeByType(type) {
    switch (type) {
    case 'image':
      return UploadMaxSize.Image;
    case 'video':
      return UploadMaxSize.Video;
    case 'audio':
      return UploadMaxSize.Audio;
    case 'pdf':
      return UploadMaxSize.Pdf;
    case 'richmenu':
      return UploadMaxSize.RichMenu;
    default:
      return UploadMaxSize.Image;
    }
  }

  /**
     * Convert mine type to file type, for example: image/png → image
     * @param {String} mineType the mine type of file
     */

  static convertMineTypeToMediaType(mineType) {
    if (ImageType.includes(mineType)) return 'image';
    if (VideoType.includes(mineType)) return 'video';
    if (AudioType.includes(mineType)) return 'audio';
    if (PdfType.includes(mineType)) return 'pdf';
  }

  /**
     * Convert file types to mine types
     * @param {Array} types array of file type
     * @returns mine types
     */
  static getAcceptedMineTypes(types) {
    const mineTypes = [];
    if (types.includes(MessageType.Image)) {
      mineTypes.push('image/jpg,image/jpeg,image/png');
    }

    if (types.includes('richmenu') || types.includes('imagemap')) {
      mineTypes.push('image/jpg,image/jpeg,image/png');
    }

    if (types.includes(MessageType.Video)) {
      mineTypes.push('video/mp4');
    }

    if (types.includes(MessageType.Audio)) {
      mineTypes.push('audio/m4a,audio/x-m4a,audio/mpeg,audio/mpeg3,audio/x-mpeg-3,audio/wav,audio/ogg');
    }

    if (types.includes('pdf')) {
      mineTypes.push('application/pdf');
    }

    return mineTypes.join(',');
  }

  static validateFileSizeByType(type, size) {
    const result = {
      valid: true
    };

    if (type === 'image' && size > UploadMaxSize.Image) {
      result.valid = false;
      result.message = '画像ファイルの最大容量は10MBになります。';
    } else if (type === 'imagemap' && size > UploadMaxSize.Image) {
      result.valid = false;
      result.message = '画像ファイルの最大容量は10MBになります。';
    } else if (type === 'video' && size > UploadMaxSize.Video) {
      result.valid = false;
      result.message = 'ビデオファイルの最大容量は200MBになります。';
    } else if (type === 'audio' && size > UploadMaxSize.Audio) {
      result.valid = false;
      result.message = 'オーディオファイルの最大容量は200MBになります。';
    } else if (type === 'pdf' && size > UploadMaxSize.Pdf) {
      result.valid = false;
      result.message = 'オーディオファイルの最大容量は10MBになります。';
    } else if (type === 'richmenu' && size > UploadMaxSize.RichMenu) {
      result.valid = false;
      result.message = '画像ファイルの最大容量は1MBになります。';
    }

    return result;
  }

  static async validateFileByMimeBytes(even, type, url, mineType) {
    let result = {
      valid: true
    };

    if (['video/mp4', 'audio/mp4'].includes(mineType.toString()) && type === 'audio') {
      result = this.messageError();
      return result;
    }

    // get first 4 bytes of header
    const arr = (new Uint8Array(even.target.result)).subarray(0, 4);
    let header = '';
    for (let i = 0; i < arr.length; i++) {
      header += arr[i].toString(16);
    }

    if ((type === 'video' || type === 'audio')) {
      let total = 0;
      for (let i = 0; i < arr.length - 1; i++) {
        total += arr[i];
      }

      if (total === 0) {
        const isValidFileUploadIsVideo = await this.validateFileIsVideo(url);
        if ((type === 'video' && isValidFileUploadIsVideo) || (type === 'audio' && !isValidFileUploadIsVideo)) {
          return result;
        }
      }
    }

    const isValidType = await this.isValidMineType(type, header);
    if (!isValidType) {
      result = this.messageError();
    }

    return result;
  }

  static isValidMineType(type, fileHeader) {
    if (type === 'image' || type === 'richmenu' || type === 'imagemap') {
      return ImageMimeBytes.includes(fileHeader.toString());
    } else if (type === 'video') {
      return VideoMimeBytes.includes(fileHeader.toString());
    } else if (type === 'audio') {
      return AudioMimeBytes.includes(fileHeader.toString());
    } else if (type === 'pdf') {
      return PdfMimeBytes.includes(fileHeader.toString());
    } else if (!type) {
      return false;
    }
  }

  static validateFileIsVideo(url) {
    // eslint-disable-next-line promise/param-names
    return new Promise((res, rej) => {
      const video = document.createElement('video');
      video.preload = 'metadata';
      video.onloadedmetadata = (evt) => {
        res(!!(video.videoHeight && video.videoWidth));
        video.src = null;
      };
      video.src = url;
    });
  }

  static getDuration(data) {
    const durationInMilis = data.duration;
    const duration = moment.duration(durationInMilis / 1000, 'seconds');
    return `${duration.minutes()}:${duration.seconds()}`;
  }

  static messageError() {
    const result = {
      valid: false,
      message: 'ファイルの形式が無効です。'
    };
    return result;
  }
}

export default Media;
