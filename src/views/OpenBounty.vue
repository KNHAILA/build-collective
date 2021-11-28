<template lang="html">
<div class="home">
  <form @submit.prevent="createBug">
    <card
      title="Create a Bounty" :blue="true"
      subtitle="Please enter the requested informations."
    >
    
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

      <span class="input-username">Balance of tokens : </span>
      <input
        type="number"
        class="input-username"
        v-model="enterprise_balance"
        placeholder="Enter a number"
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
  name: 'OpenBounty',
  components: { Card },
  setup() {
    const store = useStore()
    const address = computed(() => store.state.account.address)
    const contract = computed(() => store.state.contract)
    return { address, contract }
  },
  data() {
    const id = this.$route.query.id
    const userAddress = this.$route.query.ownerAddress
    const title = ''
    const description = ''
    const ETH_reward = 0
    const git_link = ''

    return { 
        id, 
        userAddress, 
        title, 
        description, 
        ETH_reward, 
        git_link }
  },
  methods: {
    async createBug() {
      const { contract, userAddress, title, description, ETH_reward, git_link } =
        this
      await contract.methods
        .createBug(userAddress, title, description, ETH_reward, git_link)
        .send()
        this.$router.push({
        //////
      })
    },
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


