<template>
  <section>

    <div v-if="isLoading">
      Loading...
    </div>
    <div v-else-if="isError">
      ERR:ERR
      <button @click="fetchData()"> RETRY</button>
    </div>
    <div v-else-if="responseLists.length === 0" style="padding: 10px; text-align: center;">
      データなし
    </div>
    <div v-else class="">
      <div v-for="(object, index) of responseLists" :key="index" class="cardView">
        <div class="question-list">
          <div style="width: 200px; font-weight: bold;">回答日時</div>
          <div>{{object.created}}</div>
        </div>
        <div class="question-list">
          <div style="width: 200px; font-weight: bold;">回答者名</div>
          <div style="max-width: 300px; overflow: hidden; text-overflow: ellipsis">{{object.display_name ||
            object.line_name}}
          </div>
        </div>

        <div class="question-list">
          <div style="width: 200px; font-weight: bold;"> 回答内容</div>
          <div>
            <div v-for="(question, index) of object.questions" :key="index" class="question">
              <div style=" vertical-align: top; padding: 10px; display: flex">
                <div class="num">
                  {{question.content.text}}<span style="color: red; font-weight: bold"
                                                   v-if="question.is_required">*</span>
                </div>

              </div>
              <div style="vertical-align: top; padding: 10px; position: relative" v-if="question.answers.length > 0">
                <div v-if="question.answers[0].content.type === 'file'">
                  <img style="width: 150px; margin-bottom: 10px"
                       :src="`${MIX_SERVEY_MEDIA_FLEXA_URL}/${question.answers[0].content.content.alias}`"
                       v-if="question.answers[0].content.content.mine_type.includes('image/')">
                  <div style="width: 150px; font-size: 60px" v-else><i class="fa fa-file"></i></div>
                  <div>
                    <a style="color: #00B900"
                       :href="`${MIX_SERVEY_MEDIA_FLEXA_URL}/${question.answers[0].content.content.alias}`"
                       target="_blank">
                      <i
                        class="fa fa-download"></i><span>{{trimMidString(question.answers[0].content.content.name, 25, 10)}}</span>
                    </a>
                  </div>
                </div>
                <div v-else style="max-width: 250px; word-break: break-word;">
                  {{autoText(question.answers[0].content.content)}}
                </div>

                <!--{{answer.content}}-->
              </div>
              <div style="vertical-align: top; padding: 10px; position: relative; color: #a9a9a9" v-else>
                No answer
              </div>

            </div>

          </div>

        </div>
        <div class="row-ttl02 flex">
        <div class="btn-common02 fz14">
          <a :href="`${MIX_ROOT_PATH}/friends/`+ object.line_customer.friend.id + `/detail`">友だち詳細</a>
        </div>
        <div class="btn-common02 fz14">
          <a :href="`${MIX_ROOT_PATH}/talks/to/`+ object.channel_alias">トーク画面</a>
        </div>
      </div>
      </div>
    </div>
  </section>
</template>

<script>
export default {
  props: ['data', 'route'],

  data() {
    return {
      MIX_SERVEY_MEDIA_FLEXA_URL: process.env.MIX_SERVEY_MEDIA_FLEXA_URL,
      MIX_ROOT_PATH: process.env.MIX_ROOT_PATH,
      responseLists: [],
      userSelected: null,
      isLoading: true,
      isError: false
    };
  },

  beforeMount() {
    this.fetchData();
  },

  methods: {
    fetchData() {
      this.isLoading = true;
      this.isError = false;
      this.$store.dispatch('survey/answersOfCustomer', { id: this.data })
        .then((res) => {
          this.responseLists = res;
          this.isLoading = false;
        })
        .catch(() => {
          // show error
          this.isLoading = false;

          this.isError = true;
        });
    },
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
<style lang="scss" scoped>
  ::v-deep {
    .cardView {
      padding: 20px;
      border-radius: 4px;
      box-shadow: 2px 2px 12px 0px #ededed;
      margin-bottom: 20px;
    }
    .question-list {
      display: flex;
      margin-bottom: 15px;
    }

    .question {
      display: flex;
      cursor: pointer;
    }
    .question .num {
      width: 200px;
    }

    .question .num:hover {
      font-weight: bold;
    }

    @media screen and (max-width: 991px) {
      .question {
        flex-direction: column;
        border-bottom: 1px solid #ededed;
      }
      .question-list {
        flex-direction: column;
      }
    }
  }

</style>
