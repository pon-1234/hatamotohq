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
      mineTypes.push('image/*');
    }

    if (types.includes('richmenu') || types.includes('imagemap')) {
      mineTypes.push('image/jpg,image/jpeg,image/png');
    }

    if (types.includes(MessageType.Video)) {
      mineTypes.push('video/mp4');
    }

    if (types.includes(MessageType.Audio)) {
      mineTypes.push('audio/m4a,audio/x-m4a');
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

    if ((type === 'image' || 'imagemap') && size > UploadMaxSize.Image) {
      result.valid = false;
      result.message = '画像ファイルの最大容量は10MBになります。';
    } else if (type === 'video' && size > UploadMaxSize.Video) {
      result.valid = false;
      result.message = 'ビデオファイルの最大容量は200MBになります。';
    } else if (type === 'audio' && size > UploadMaxSize.Audio) {
      result.valid = false;
      result.message = 'オーディオファイルの最  大容量は200MBになります。';
    } else if (type === 'pdf' && size > UploadMaxSize.Pdf) {
      result.valid = false;
      result.message = 'オーディオファイルの最大容量は10MBになります。';
    } else if (type === 'richmenu' && size > UploadMaxSize.RichMenu) {
      result.valid = false;
      result.message = '画像ファイルの最大容量は1MBになります。';
    }
    return result;
  }

  static validateFileByMimeBytes(even, type) {
    const result = {
      valid: true
    };
      // get first 4 bytes of header
    const arr = (new Uint8Array(even.target.result)).subarray(0, 4);
    let header = '';
    for (let i = 0; i < arr.length; i++) {
      header += arr[i].toString(16);
    }
    if (!this.isValidMineType(type, header)) {
      result.valid = false;
      result.message = 'ファイルの形式が無効です。';
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

  static getDuration(data) {
    const durationInMilis = data.duration;
    const duration = moment.duration(durationInMilis / 1000, 'seconds');
    return `${duration.minutes()}:${duration.seconds()}`;
  }

  static async downloadMedia(element) {
    const media = await fetch(element.url);
    const mediaBlog = await media.blob();
    const mediaURL = URL.createObjectURL(mediaBlog);

    const link = document.createElement('a');
    link.href = mediaURL;
    link.download = element.filename;
    document.body.appendChild(link);
    link.click();
    document.body.removeChild(link);
  }
}

export default Media;