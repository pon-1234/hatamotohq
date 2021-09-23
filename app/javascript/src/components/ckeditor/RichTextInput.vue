<template>
  <div>
    <ckeditor
      v-model="value"
      :config="editorConfig"
      :editor="editor"
      @input="onInput"
      :disabled="disabled ? true : false"
    />
  </div>
</template>

<script>

import ClassicEditor from '@ckeditor/ckeditor5-editor-classic/src/classiceditor';

import Autoformat from '@ckeditor/ckeditor5-autoformat/src/autoformat';
import BlockQuote from '@ckeditor/ckeditor5-block-quote/src/blockquote';
import BoldPlugin from '@ckeditor/ckeditor5-basic-styles/src/bold';
import EssentialsPlugin from '@ckeditor/ckeditor5-essentials/src/essentials';
import Heading from '@ckeditor/ckeditor5-heading/src/heading';
import Image from '@ckeditor/ckeditor5-image/src/image';
import ImageCaption from '@ckeditor/ckeditor5-image/src/imagecaption';
import ImageStyle from '@ckeditor/ckeditor5-image/src/imagestyle';
import ImageUpload from '@ckeditor/ckeditor5-image/src/imageupload';
import ImageToolbar from '@ckeditor/ckeditor5-image/src/imagetoolbar';
import ImageResize from '@ckeditor/ckeditor5-image/src/imageresize';
import Indent from '@ckeditor/ckeditor5-indent/src/indent';
import ItalicPlugin from '@ckeditor/ckeditor5-basic-styles/src/italic';
import LinkPlugin from '@ckeditor/ckeditor5-link/src/link';
import ListStyle from '@ckeditor/ckeditor5-list/src/list';
import MediaEmbed from '@ckeditor/ckeditor5-media-embed/src/mediaembed';
import ParagraphPlugin from '@ckeditor/ckeditor5-paragraph/src/paragraph';
import PasteFromOffice from '@ckeditor/ckeditor5-paste-from-office/src/pastefromoffice';
import Table from '@ckeditor/ckeditor5-table/src/table';
import TableToolbar from '@ckeditor/ckeditor5-table/src/tabletoolbar';
import TextTransformation from '@ckeditor/ckeditor5-typing/src/texttransformation';
import Alignment from '@ckeditor/ckeditor5-alignment/src/alignment';
import Underline from '@ckeditor/ckeditor5-basic-styles/src/underline';
import IndentBlock from '@ckeditor/ckeditor5-indent/src/indentblock';
import TableProperties from '@ckeditor/ckeditor5-table/src/tableproperties';
import TableCellProperties from '@ckeditor/ckeditor5-table/src/tablecellproperties';
// eslint-disable-next-line no-unused-vars
import translation from '@ckeditor/ckeditor5-build-classic/build/translations/ja';
import Font from '@ckeditor/ckeditor5-font/src/font';
import HorizontalLine from '@ckeditor/ckeditor5-horizontal-line/src/horizontalline';

// pending upload image
import UploadImageAdapter from '@/core/upload_image_adapter';
import HtmlEmbed from '@ckeditor/ckeditor5-html-embed/src/htmlembed';

export default {
  props: ['value', 'disabled'],
  data() {
    return {
      editor: ClassicEditor,
      editorConfig: {
        plugins: [
          Autoformat,
          BlockQuote,
          BoldPlugin,
          EssentialsPlugin,
          Heading,
          Image,
          ImageUpload,
          ImageResize,
          ImageToolbar,
          ImageCaption,
          ImageStyle,
          Indent,
          ItalicPlugin,
          LinkPlugin,
          ListStyle,
          MediaEmbed,
          ParagraphPlugin,
          PasteFromOffice,
          Table,
          TableToolbar,
          TextTransformation,
          Alignment,
          Underline,
          IndentBlock,
          TableProperties,
          TableCellProperties,
          Font,
          HorizontalLine,
          HtmlEmbed
        ],
        fontSize: {
          options: [
            9 + 'px',
            10 + 'px',
            11 + 'px',
            12 + 'px',
            13 + 'px',
            14 + 'px',
            15 + 'px',
            16 + 'px',
            17 + 'px',
            18 + 'px',
            19 + 'px',
            20 + 'px',
            21 + 'px',
            22 + 'px',
            22 + 'px',
            23 + 'px',
            24 + 'px',
            25 + 'px',
            26 + 'px',
            27 + 'px',
            28 + 'px',
            29 + 'px',
            30 + 'px',
            31 + 'px',
            32 + 'px',
            33 + 'px',
            34 + 'px',
            35 + 'px',
            36 + 'px',
            37 + 'px',
            38 + 'px'
          ]
        },
        fontColor: {
          colors: [
            {
              color: 'hsl(0, 0%, 0%)',
              label: 'Black'
            },
            {
              color: 'hsl(0, 0%, 30%)',
              label: 'Dim grey'
            },
            {
              color: 'hsl(0, 0%, 60%)',
              label: 'Grey'
            },
            {
              color: 'hsl(0, 0%, 90%)',
              label: 'Light grey'
            },
            {
              color: 'hsl(0, 0%, 100%)',
              label: 'White',
              hasBorder: true
            },
            {
              color: 'hsl(0, 75%, 60%)',
              label: 'Red'
            },
            {
              color: 'hsl(30, 75%, 60%)',
              label: 'Orange'
            },
            {
              color: 'hsl(60, 75%, 60%)',
              label: 'Yellow'
            },
            {
              color: 'hsl(90, 75%, 60%)',
              label: 'Light green'
            },
            {
              color: 'hsl(120, 75%, 60%)',
              label: 'Green'
            },
            {
              color: 'hsl(150, 75%, 60%)',
              label: 'Aquamarine'
            },
            {
              color: 'hsl(180, 75%, 60%)',
              label: 'Turquoise'
            },
            {
              color: 'hsl(210, 75%, 60%)',
              label: 'Light blue'
            },
            {
              color: 'hsl(240, 75%, 60%)',
              label: 'Blue'
            },
            {
              color: 'hsl(270, 75%, 60%)',
              label: 'Purple'
            }
          ],
          columns: 5
        },
        toolbar: {
          items: [
            'heading',
            '|',
            'fontSize',
            'fontColor',
            'bold',
            'italic',
            'underline',
            'link',
            'bulletedList',
            'numberedList',
            '|',
            'HtmlEmbed',
            'indent',
            'outdent',
            'alignment',
            '|',
            'imageUpload',
            'insertTable',
            'mediaEmbed',
            'blockQuote',
            'horizontalLine',
            'undo',
            'redo'
          ]
        },
        heading: {
          options: [
            { model: 'paragraph', title: 'Paragraph', class: 'ck-heading_paragraph' },
            { model: 'heading1', view: 'h1', title: 'Heading 1', class: 'ck-heading_heading1' },
            { model: 'heading2', view: 'h2', title: 'Heading 2', class: 'ck-heading_heading2' },
            { model: 'heading3', view: 'h3', title: 'Heading 3', class: 'ck-heading_heading3' }
          ]
        },
        mediaEmbed: {
          removeProviders: ['instagram', 'twitter', 'googleMaps', 'flickr', 'facebook'],
          previewsInData: false
        },
        image: {
          toolbar: [
            'imageTextAlternative',
            'imageStyle:alignLeft',
            'imageStyle:full',
            'imageStyle:alignRight'
          ],
          styles: [
            'alignLeft',
            'full',
            'alignRight'
          ],
          resizeOptions: [
            {
              name: 'imageResize:original',
              label: 'Original',
              value: null
            },
            {
              name: 'imageResize:50',
              label: '50%',
              value: '50'
            },
            {
              name: 'imageResize:75',
              label: '75%',
              value: '75'
            }
          ]
        },
        htmlEmbed: {
          showPreviews: false
        },
        language: 'ja',
        table: {
          contentToolbar: [
            'tableColumn', 'tableRow', 'mergeTableCells',
            'tableProperties', 'tableCellProperties'
          ]
        },
        extraPlugins: [this.uploader]
      }
    };
  },
  methods: {
    onInput() {
      this.$emit('update:value', this.value);
    },
    uploader(editor) {
      editor.plugins.get('FileRepository').createUploadAdapter = (loader) => {
        return new UploadImageAdapter(loader);
      };
    }
  }
};
</script>

<style lang="scss" scoped>
::v-deep {
  // Customer css ck
  .ck.ck-editor__editable_inline {
    min-height: 300px!important;
    max-height: 700px;
  }

  .ck-content figure.image-style-align-right {
    margin-left: 5%;
  }

  .ck-content figure.image-style-align-left {
    margin-right: 5%;
  }

  .ck.ck-dropdown {
    ul {
      overflow-y: scroll;
      overflow-x: hidden;
      height: 250px;
    }
  }
  * {
    scrollbar-width: thin;
    scrollbar-color: transparent;
  }
  *::-webkit-scrollbar {
    width: 8px;
  }
  *::-webkit-scrollbar-thumb {
    background-color: #ccc;
    border-radius: 10px;
  }
  .ck-toolbar__items {
    flex-wrap: wrap!important;
  }
}
</style>