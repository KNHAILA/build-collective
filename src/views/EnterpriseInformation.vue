
<template lang="html">

<div class="home-wrapper">
    <card
      title= "Your Enterprise Information"
      :subtitle="`${enterprise_account.name}`"
      v-if="enterprise_account"
    >
      <div class="explanations" v-if="enterprise_account">
        <p><b>Owner: </b>{{ this.enterprise_owner.username }}</p>
        <p><b>Owner's Address: </b>{{ enterprise_account.user }}</p>
        <p><b>Balance: </b>{{ enterprise_account.balance }} Tokens</p>
        <div>
          <b>Members: </b>
          <p
            v-for="member in enterprise_members"
            v-bind:key="member.address"
            style="padding-left: 10px"
          >
            Account Name: {{ member.account.username }} &nbsp; Address:
            {{ member.address }}
          </p>
        </div>
      </div>
    </card>
    </div>
  
</template>

<script lang="ts">
import { defineComponent, computed } from 'vue'
import { useStore } from 'vuex'
import Card from '@/components/Card.vue'

export default defineComponent({
  name: 'EnterpriseInformation',
  components: { Card },
  setup() {
    const store = useStore()
    const address = computed(() => store.state.account.address)
    const contract = computed(() => store.state.contract)
    return { address, contract }
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
    getEnterpriseMembers(memberAddress: string) {
      return this.contract.methods.getUser(memberAddress).call()
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
    if (enterprise_account.name) {
      this.enterprise_account = enterprise_account
      this.enterprise_owner = await contract.methods.getUser(enterprise_account.user).call()
      const members = enterprise_account.membersAddress
      for (const member_address of members) {
        const member = await contract.methods
          .getUser(member_address)
          .call()
        this.enterprise_members.push({
          address: member_address,
          account: {
            username: member.username,
            balance: member.balance
          },
        })
      }
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