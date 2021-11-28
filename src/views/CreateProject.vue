<template lang="html">
  <form @submit.prevent="createProject" class="home-wrapper">
    <card title="Create a project" :blue="true">
      <div v-if="enterprise_account">
        <span class="input-username">Choose the project owner</span>
          <select  v-model="ownerType">
            <option id="user" value="false">
            {{ enterprise_account.name }}
            </option>
            <option   id="user" value="true"> 
            {{ account.username }}
            </option>
          </select>
      </div>
      <input
        type="text"
        class="input-username"
        v-model="project_name"
        placeholder="Type Project Name"
      />
      <input
        type="text"
        class="input-username"
        v-model="project_link"
        placeholder="Type Project  Github or Gitlab Link"
      />
      <span class="input-username">Choose one or multiple contributors</span>
      <div
        v-for="user in users"
        v-bind:key="user.address"
        class="input-username"
      >
      <input
          type="checkbox"
          :id="user.address"
          :value="user.address"
          v-model="project_contributors"
        />
        <span>{{ user.account.username }}</span>
      </div>
      <input
        type="number"
        class="input-username"
        v-model="project_balance"
        placeholder="Balance of tokens"
      />
      <button type="submit" class="input-username">Submit</button>
    </card>
  </form>
</template>

<script lang="ts">
import { computed, defineComponent } from 'vue'
import { useStore } from 'vuex'
import Card from '@/components/Card.vue'

export default defineComponent({
  name: 'CreateProject',
  components: { Card },
  setup() {
    const store = useStore()
    const address = computed(() => store.state.account.address)
    const contract = computed(() => store.state.contract)
    return { address, contract }
  },
  data() {
    const account = null
    const users: any[] = []
    const enterprise_account = null
    const project = null
    const ownerType = 'true'
    const project_name = ''
    const project_balance = ''
    const project_link = ''
    const project_contributors: never[] = []
    return {
      account,
      enterprise_account,
      project,
      users,
      project_name,
      project_link,
      project_balance,
      ownerType,
      project_contributors,
    }
  },
  methods: {
    async updateAccount() {
      const { address, contract } = this
      this.account = await contract.methods.getUser(address).call()
    },
    async createProject() {
      const {
        contract,
        project_name,
        project_link,
        project_balance,
        ownerType,
        project_contributors,
      } = this
      const name = project_name.trim().replace(/ /g, '_')
      await contract.methods
        .createProject(
          name,
          project_link,
          project_balance,
          ownerType,
          project_contributors,
        )
        .send()
      await this.$router.push({ name: 'Account' })
    },
  },

  async mounted() {
    const { address, contract } = this
    const account = await contract.methods.getUser(address).call()
    if (account.registered) this.account = account

    const enterprise_account = await contract.methods
      .getEnterprise(address)
      .call()
    if (enterprise_account.name) this.enterprise_account = enterprise_account

    const users = await contract.methods.getAllUsers().call()
    for (const userAddresse of users) {
      const account = await contract.methods
        .getUser(userAddresse)
        .call()
      this.users.push({ address: userAddresse, account: account })
    }
  },
})
</script>

<style lang="css" scoped>
.home {
  padding: 24px;
  flex: 1;
  display: flex;
  flex-direction: column;
  justify-content: center;
  max-width: 500px;
  margin: auto;
}

.explanations {
  padding: 12px;
}

.button-link {
  display: inline;
  appearance: none;
  border: none;
  background: none;
  color: inherit;
  text-decoration: underline;
  font-family: inherit;
  font-size: inherit;
  font-weight: inherit;
  padding: 0;
  margin: 0;
  cursor: pointer;
}

.input-username {
  background: transparent;
  border: none;
  padding: 12px;
  outline: none;
  width: 100%;
  color: white;
  font-family: inherit;
  font-size: 1.3rem;
}
.v-divider {
    border-color: white;
    color: white;
}
.home-wrapper {
  margin: auto 24px auto 24px;
  display: grid;
  align-items: center;
  grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
  grid-gap: 24px;
}


</style>