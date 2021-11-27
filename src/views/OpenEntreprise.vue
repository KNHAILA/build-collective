<template lang="html">
<div class="home">
  <form @submit.prevent="registerEnterprise">
    <card
      title="Create your enterprise"
    >
    </card>
  
    <card>
      <span class="input-username">Enter a name : </span>
      <input
        type="text"
        class="input-username"
        v-model="enterprise_name"
        placeholder="Enterprise name"
      />
      <span class="input-username">Select members : </span>
      <div
        v-for="user in users"
        v-bind:key="user.address"
        class="input-username"
      >
        <input
          type="checkbox"
          :id="user.address"
          :value="user.address"
          v-model="enterprise_members"
        />
        <span>{{ user.account.username }}</span>
      </div>

      <span class="input-username">Choose a balance of tokens : </span>
      <input
        type="number"
        class="input-username"
        v-model="enterprise_balance"
        placeholder="Balance of tokens"
      />
      
    </card>
  </form>
    
  <form @submit.prevent="registerEnterprise">
    <button type="submit" class="input-username">Submit</button>
  </form>
  </div>

</template>

<script lang="ts">
import { computed, defineComponent } from 'vue'
import { useStore } from 'vuex'
import Card from '@/components/Card.vue'

export default defineComponent({
  name: 'OpenEnterprise',
  components: { Card },
  setup() {
    const store = useStore()
    const address = computed(() => store.state.account.address)
    const contract = computed(() => store.state.contract)
    return { address, contract }
  },
  data() {
    const users: any[] = []
    const enterprise_account = null
    const enterprise_name = ''
    const enterprise_balance = ''
    const enterprise_members: never[] = []
    return {
      enterprise_name,
      users,
      enterprise_account,
      enterprise_members,
      enterprise_balance,
    }
  },
  methods: {
    async registerEnterprise() {
      const { contract, enterprise_name, enterprise_members, enterprise_balance, address } =
        this
      await contract.methods
        .registerEnterprise(enterprise_name, enterprise_members, enterprise_balance)
        .send()
      this.enterprise_account = await contract.methods
        .getEnterprise(address)
        .call()
      await this.$router.push({ name: 'Account' })
    },
  },

  async mounted() {
    const { address, contract } = this
    this.enterprise_account = await contract.methods
      .getEnterprise(address)
      .call()
    const allUsers = await contract.methods.getAllUsers().call()
    for (const userAddresse of allUsers) {
      const account = await contract.methods
        .getUser(userAddresse)
        .call()
      this.users.push({ address: userAddresse, account: account }) 
    }
  },
})

</script>

<style lang="css" scoped>

.label, input {
    display: block;
}

.label {
    margin-top: 20px;
}

.home {
  padding: 24px;
  flex: 1;
  display: flex;
  flex-direction: column;
  justify-content: center;
  max-width: 100%;
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

.select-type,
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
</style>


