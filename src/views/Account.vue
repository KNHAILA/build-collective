<template lang="html">

  <div class="home" v-if="!account">
    <form @submit.prevent="signUp">
      <card
        title="Open a user account"
        subtitle="With name and balance"
      >
        <input
          type="text"
          class="input-username"
          v-model="username"
          placeholder="Type the username here"
        />
         <input
          type="number"
          class="input-username"
          v-model="userbalance"
          placeholder="Type the balance of tokens"
        />
        <button type="submit" class="input-username">Open</button>
      </card>
    </form>
  </div>


  <div v-if="account">
    <div class="card-home-wrapper">
      <card
        :title="account.username"
        :subtitle="`${balance} Ξ\t\t${account.balance} Tokens`"
        :gradient="true"
      >
        <div class="explanations">
          <p><b>Address: </b>{{ address }}</p>
          <v-divider></v-divider>
          <p><b>ETH: </b>{{ balance }}</p>
          <v-divider></v-divider>
          <p><b>Balance: </b>{{ account.balance }} Tokens</p>
        </div>
      </card>
    </div>
  </div>


    <div class="home-wrapper">
      <card v-if="!enterprise_account">
        <router-link class="card-body" to="/open-entreprise">
          Register an entreprise
        </router-link>
      </card>
      <card v-if="enterprise_account">
        <router-link class="card-body" to="/entreprise_information">
          See your entreprise information
        </router-link>
      </card>
       <card>
        <router-link class="card-body" to="/create-project">
          Create your project
        </router-link>
      </card>
       <card>
        <router-link class="card-body" to="/view-projects">
          View all the projects
        </router-link>
      </card>
    </div>
  
</template>

<script lang="ts">
import { defineComponent, computed } from 'vue'
import { useStore } from 'vuex'
import Card from '@/components/Card.vue'

export default defineComponent({
  components: { Card },
  setup() {
    const store = useStore()
    const address = computed(() => store.state.account.address)
    const balance = computed(() => store.state.account.balance)
    const contract = computed(() => store.state.contract)
    return { address, contract, balance }
  },
  data() {
    //user
    const account = null
    const username = ''
    const userbalance = ''
    //enterprise
    const enterprise_owner: any = { username: '', balance: 0 }
    const enterprise_account = null
    const enterprise_members: any[] = []

    return {
       account,
       username,
       userbalance,
       enterprise_owner,
       enterprise_account,
       enterprise_members,
       }
  },
  methods: {
    //user
    async updateAccount() {
      const { address, contract } = this
      this.account = await contract.methods.getUser(address).call()
    },
    async signUp() {
      const { contract, username, userbalance } = this
      const name = username.trim().replace(/ /g, '_')
      await contract.methods.signUp(name, userbalance).send()
      await this.updateAccount()
      this.username = ''
    },
    async addTokens() {
      const { contract } = this
      await contract.methods.addBalance(200).send()
      await this.updateAccount()
    },
  },
  async mounted() {
    //user
    const { address, contract } = this
    const account = await contract.methods.getUser(address).call()
    if (account.registered) this.account = account

    //enterprise
    const enterprise_account = await contract.methods
      .getEnterprise(address)
      .call()
    if (enterprise_account.name) { this.enterprise_account = enterprise_account }

    //projects
    

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
