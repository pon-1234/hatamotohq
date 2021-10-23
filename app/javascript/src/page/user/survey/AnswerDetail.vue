<template>
  <section>
    <div class="row-ttl01 flex ai_center mb40 flex-wrap justify-content-between">
      <h3 class="hdg3">回答内容詳細</h3>
      <div class="row-ttl02 flex">
        <div class="btn-common02 fz14">
          <a :href="`${MIX_ROOT_PATH}/friends/` + answer.line_customer.friend.id + `/detail`">友だち詳細</a>
        </div>
        <div class="btn-common02 fz14">
          <a :href="`${MIX_ROOT_PATH}/talks/to/` + answer.channel_alias">トーク画面</a>
        </div>
        <div class="btn-common02 fz14">
          <a :href="`${MIX_ROOT_PATH}/surveys/` + answer.survey_id + `/answer/` + answer.id + `/pdf`"
            >PDFダウンロード</a
          >
        </div>
      </div>
    </div>
    <div class="row mb40">
      <div class="col-md-6 col-xs-12">
        <h3 class="hdg3">{{ answer.survey_title }}</h3>
        <div class="row">
          <div class="col-md-4">回答日時</div>
          <div class="col-md-8">{{ answer.created }}</div>
        </div>
        <div class="row">
          <div class="col-md-4">回答者名</div>
          <div class="col-md-8">{{ answer.display_name ? answer.display_name : answer.line_name }}</div>
        </div>
      </div>
    </div>
    <div class="">
      <h3 class="hdg3">回答内容</h3>
      <div class="tag-scroll">
        <div class="tbl-admin01 tbl-linebot01 table-responsive fz14 text-center">
          <table class="table table-hover table-message-content">
            <thead>
              <tr>
                <th class="w10">質問</th>
                <th class="w15">回答</th>
              </tr>
            </thead>
            <tbody>
              <tr v-for="(question, index) of answer.questions" :key="index">
                <td>
                  {{ question.content.text }}
                </td>
                <td>
                  <div
                    style="vertical-align: top; padding: 10px; position: relative"
                    v-if="question.answers.length > 0"
                  >
                    <div v-if="question.answers[0].content.type === 'file'">
                      <img
                        style="width: 150px; margin-bottom: 10px"
                        :src="`${MIX_SERVEY_MEDIA_FLEXA_URL}/${question.answers[0].content.content.alias}`"
                        v-if="question.answers[0].content.content.mine_type.includes('image/')"
                      />
                      <div style="width: 150px; font-size: 60px" v-else><i class="fa fa-file"></i></div>
                      <div>
                        <a
                          style="color: #00b900"
                          :href="`${MIX_SERVEY_MEDIA_FLEXA_URL}/${question.answers[0].content.content.alias}`"
                          target="_blank"
                        >
                          <i class="fa fa-download"></i
                          ><span>{{ trimMidString(question.answers[0].content.content.name, 25, 10) }}</span>
                        </a>
                      </div>
                    </div>
                    <span v-else style="max-width: 250px; word-break: break-word; text-align: center">
                      {{ autoText(question.answers[0].content.content) }}
                    </span>

                    <!--{{answer.content}}-->
                  </div>
                  <div style="vertical-align: top; padding: 10px; position: relative; color: #a9a9a9" v-else>
                    No answer
                  </div>
                </td>
              </tr>
            </tbody>
          </table>
        </div>
      </div>
    </div>
  </section>
</template>

<script>
export default {
  props: ['data'],
  data() {
    return {
      MIX_SERVEY_MEDIA_FLEXA_URL: process.env.MIX_SERVEY_MEDIA_FLEXA_URL,
      MIX_ROOT_PATH: process.env.MIX_ROOT_PATH,
      answer: this.data
    };
  },
  created() {
    console.log(this.data);
  },
  methods: {
    trimMidString(originStr, maxChars, trailingCharCount) {
      let shrinkedStr = originStr;
      const shrinkedLength = maxChars - trailingCharCount - 3;
      if (originStr.length > shrinkedLength) {
        const front = originStr.substr(0, shrinkedLength);
        const mid = '...';
        const end = originStr.substr(-trailingCharCount);
        shrinkedStr = front + mid + end;
      }

      return shrinkedStr;
    },
    autoText(data) {
      if (Array.isArray(data)) {
        let str = '';
        data.forEach((text, index) => {
          if (index > 0) {
            str += ', ';
          }
          str += text;
        });

        return str;
      }
      return data;
    }
  }
};
</script>
