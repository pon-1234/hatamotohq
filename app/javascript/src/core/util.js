import {
  MessageType,
  ActionObjectsType,
  MessageTypeIds
} from './constant';
import moment from 'moment';

class Util {
  static showSuccessThenRedirect(message, redirectTo) {
    window.toastr.success(message);
    setTimeout(() => {
      window.location.href = redirectTo;
    }, 1500);
  }

  static showErrorThenRedirect(message, redirectTo) {
    window.toastr.error(message);
    setTimeout(() => {
      window.location.href = redirectTo;
    }, 1500);
  }

  static getCsrfToken() {
    const tokenDom = document.head.querySelector('meta[name="csrf-token"]');
    return tokenDom ? tokenDom.content : null;
  }

  static formattedDate(date) {
    return moment(date, 'YYYY-MM-DD').tz('Asia/Tokyo').format('YYYY年MM月DD日');
  }

  static formattedTime(datetime) {
    return moment(datetime, 'YYYY-MM-DD HH:mm:ss Z').tz('Asia/Tokyo').format('HH:mm');
  }

  static formattedDatetime(datetime) {
    return moment(datetime, 'YYYY-MM-DD HH:mm:ss Z').tz('Asia/Tokyo').format('YYYY年MM月DD日 HH:mm');
  }

  static getDuration(data) {
    const durationInMilis = data.duration;
    const duration = moment.duration(durationInMilis / 1000, 'seconds');
    return `${duration.minutes()}:${duration.seconds()}`;
  }

  static setDefaultFormatDate(date) {
    return moment(date).format('YYYY-MM-DD');
  }

  static checkMessageContentForPreview(item) {
    if (item.content.type === MessageType.Text && !item.content.text) {
      return true;
    }

    if (item.content.type === MessageType.Sticker && !item.content.stickerId) {
      return true;
    }

    if ((item.content.type === MessageType.Image || item.content.type === MessageType.Video) && (!item.content.originalContentUrl || !item.content.previewImageUrl)) {
      return true;
    }

    if (item.content.type === MessageType.Audio && (!item.content.originalContentUrl || !item.content.duration)) {
      return true;
    }
  }

  static checkMessageContent(item) {
    if (item.content.type === MessageType.Text && !item.content.text) {
      return true;
    }

    if (
      item.content.type === MessageType.Sticker &&
      !item.content.stickerId
    ) {
      return true;
    }

    if (
      (item.content.type === MessageType.Image ||
        item.content.type === MessageType.Video) &&
      (!item.content.originalContentUrl ||
        !item.content.previewImageUrl)
    ) {
      return true;
    }

    if (
      item.content.type === MessageType.Audio &&
      (!item.content.originalContentUrl || !item.content.duration)
    ) {
      return true;
    }

    if (
      item.message_type_id === MessageTypeIds.TemplateButtons && (!item.content.template.title || !item.content.template.text)
    ) {
      return true;
    }

    if (item.message_type_id === MessageTypeIds.TemplateConfirm && !item.content.template.text) {
      return true;
    }

    if (item.content && item.content.template && item.content.template.actions) {
      return this.validateActions(item.content.template.actions);
    }

    if (item.content && item.content.template && item.content.template.columns) {
      return this.checkConditionColums(item.content.template.columns);
    }

    return false;
  }

  static checkConditionColums(columns) {
    for (var column of columns) {
      if ('thumbnailImageUrl' in column && !column.thumbnailImageUrl) {
        return true;
      }

      if (!column.text && !column.imageUrl) {
        return true;
      }

      if (column.title && columns.find(item => !item.title)) {
        return true;
      }

      if ('imageUrl' in column && !column.imageUrl) {
        return true;
      }
    }
    if (column.actions) {
      return this.validateActions(column.actions);
    } else {
      return this.validateActions([column.action]);
    }
  }

  static validateActions(actions) {
    for (const action of actions) {
      if (this.validateAction(action)) {
        return true;
      }
    }

    return false;
  }

  static validateAction(action) {
    if (Object.values(ActionObjectsType).indexOf(action.type) < 0) {
      return true;
    }
    if ((action.type === ActionObjectsType.CameraRoll || action.type === ActionObjectsType.Camera || action.type === ActionObjectsType.Location) && !action.label) {
      return true;
    }

    if (action.type === ActionObjectsType.Message && !action.text) {
      return true;
    }

    if (action.type === ActionObjectsType.Uri) {
      if (action.id && action.id === 2 && !this.regexTel(action.uri)) {
        return true;
      }

      if (action.id && action.id === 1 && !this.validateUrl(action.uri)) {
        return true;
      }
    }

    if (action.type === ActionObjectsType.Datetimepicker && !action.data) {
      return true;
    }

    return false;
  }

  static showDeliveryTiming(val) {
    let time = val.replace(/m/m, '月');
    time = time.replace(/w/m, '週');
    time = time.replace(/d/m, '日');
    time = time.replace(/h/m, 'h');
    time = time.replace(/i/m, 'i');
    return time;
  }

  static stringStatus(val) {
    return val === true ? 'enable' : 'disable';
  }

  static isEnable(val) {
    return val === 'enable';
  }

  static isNow(val) {
    return val === 'now';
  }

  static pid() {
    return btoa('/medias/download');
  }

  static validateUrl(value) {
    return /^(?:(?:(?:https?|ftp):)?\/\/)(?:\S+(?::\S*)?@)?(?:(?!(?:10|127)(?:\.\d{1,3}){3})(?!(?:169\.254|192\.168)(?:\.\d{1,3}){2})(?!172\.(?:1[6-9]|2\d|3[0-1])(?:\.\d{1,3}){2})(?:[1-9]\d?|1\d\d|2[01]\d|22[0-3])(?:\.(?:1?\d{1,2}|2[0-4]\d|25[0-5])){2}(?:\.(?:[1-9]\d?|1\d\d|2[0-4]\d|25[0-4]))|(?:(?:[a-z\u00a1-\uffff0-9]-*)*[a-z\u00a1-\uffff0-9]+)(?:\.(?:[a-z\u00a1-\uffff0-9]-*)*[a-z\u00a1-\uffff0-9]+)*(?:\.(?:[a-z\u00a1-\uffff]{2,})))(?::\d{2,5})?(?:[/?#]\S*)?$/i.test(value);
  }

  static empty(value) {
    return value === null || value.length === 0;
  }

  static regexUrl(value) {
    return /^(?:(?:(?:https?|ftp):)?\/\/)(?:\S+(?::\S*)?@)?(?:(?!(?:10|127)(?:\.\d{1,3}){3})(?!(?:169\.254|192\.168)(?:\.\d{1,3}){2})(?!172\.(?:1[6-9]|2\d|3[0-1])(?:\.\d{1,3}){2})(?:[1-9]\d?|1\d\d|2[01]\d|22[0-3])(?:\.(?:1?\d{1,2}|2[0-4]\d|25[0-5])){2}(?:\.(?:[1-9]\d?|1\d\d|2[0-4]\d|25[0-4]))|(?:(?:[a-z\u00a1-\uffff0-9]-*)*[a-z\u00a1-\uffff0-9]+)(?:\.(?:[a-z\u00a1-\uffff0-9]-*)*[a-z\u00a1-\uffff0-9]+)*(?:\.(?:[a-z\u00a1-\uffff]{2,})))(?::\d{2,5})?(?:[/?#]\S*)?$/i;
  }

  static regexTel() {
    return /^([0-9]){1,14}$/i;
  }

  static jsonToBase64(json) {
    try {
      return btoa(encodeURIComponent(JSON.stringify(json)).replace(/%([0-9A-F]{2})/g,
        function toSolidBytes(match, p1) {
          return String.fromCharCode('0x' + p1);
        }));
    } catch (e) {
      return '';
    }
  }

  static base64ToJson(base64) {
    try {
      return JSON.parse(decodeURIComponent(Array.prototype.map.call(atob(base64), function(c) {
        return '%' + ('00' + c.charCodeAt(0).toString(16)).slice(-2);
      }).join('')));
    } catch (e) {
      return {};
    }
  }

  static firstWhere(array, cond) {
    for (const o in array) {
      if (cond(o)) {
        return o;
      }
    }
    return null;
  }

  static getParamFromUrl(query) {
    const uri = window.location.search.substring(1);
    const params = new URLSearchParams(uri);
    return params.get(query);
  }

  static isMobile() {
    if (/Android|webOS|iPhone|iPad|iPod|BlackBerry|IEMobile|Opera Mini/i.test(navigator.userAgent)) {
      return true;
    } else {
      return false;
    }
  }

  static addMouseScrollHorizontal($target) {
    let curXPos = 0;
    let curDown = false;
    $target.on({
      mousemove: function(e) {
        if (curDown) {
          $(e.currentTarget).scrollLeft(e.currentTarget.scrollLeft + (curXPos - e.pageX), 0);
          curXPos = e.pageX;
        }
      },
      mousedown: function(e) {
        curDown = true;
        curXPos = e.pageX;
      }
    });
    window.addEventListener('mouseup', function(e) {
      curDown = false;
    });
  }

  static getTimeWithFormat(value) {
    const time = value.split(':');
    return time[0] + 'h' + time[1] + 'i';
  }

  static timeConvertJp(value) {
    const matchDay = /([0-9]+)d/m.exec(value);
    let day = '0';
    if (matchDay && matchDay.length > 1) {
      day = matchDay[1];
    }

    const matchHour = /([0-9]+)h/m.exec(value);
    let hour = '00';
    if (matchHour && matchHour.length > 1) {
      hour = matchHour[1];
    }

    const matchMin = /([0-9]+)i/m.exec(value);
    let min = '00';
    if (matchMin && matchMin.length > 1) {
      min = matchMin[1];
    }

    return day + '日' + hour + '時' + min + '分';
  }

  static regexFontSize() {
    return /^(\d+px|[Xx][Xx][Ss]|[Xx][Ss]|[Ss][Mm]|[Mm][Dd]|[Ll][Gg]|[Xx][Ll]|[Xx][Xx][Ll]|3[Xx][Ll]|4[Xx][Ll]|5[Xx][Ll])$/i;
  }

  static regexFontSizeUsingPx() {
    return /^\d+px$/i;
  }

  static regexFontSizeUsingWord() {
    return /^([Xx][Xx][Ss]|[Xx][Ss]|[Ss][Mm]|[Mm][Dd]|[Ll][Gg]|[Xx][Ll]|[Xx][Xx][Ll]|3[Xx][Ll]|4[Xx][Ll]|5[Xx][Ll])$/i;
  }
}

export default Util;