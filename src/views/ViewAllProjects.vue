<template lang="html">
    <h1>Projects :</h1>
        <div v-for="project in projects" v-bind:key="project.name">
            <div style="padding: 12px">
                <card :title="project.name" :blue="true">
                <p>
                    <b>Owner of Project : </b>
                    {{ project.ownedByUser ? project.owner.username : project.owner.name }}
                </p>
                <div>
                <b>Contributors :</b>
                <p v-for="contributor in project.contributors"
                v-bind:key="contributor.address"
                style="padding-left: 10px">
                Account :
                <ul>
                    <li> Name : {{ contributor.account.username }} </li>
                    <li> Address : {{ contributor.address }}</li>
                </ul>
                </p>
            </div>
            <p><b>Balance of Project : </b>{{ project.balance }} Tokens</p>
            </card>
        </div>
    </div>
</template>

<script lang="ts">
import { computed, defineComponent } from 'vue'
import Card from '@/components/Card.vue'
import { useStore } from 'vuex'

export default defineComponent({
  name: 'ViewAllProjects',
  components: { Card },
  setup() {
    const store = useStore()
    const address = computed(() => store.state.account.address)
    const balance = computed(() => store.state.account.balance)
    const contract = computed(() => store.state.contract)
    return { address, contract, balance }
  },
  data() {
    const projects: any = []
    return { projects }
  },
  async mounted() {
   const userAddresses = await this.contract.methods.getAllUsers().call()
    for (const address of userAddresses) {
      const projects = await this.contract.methods.getProject(address).call()
     if (projects.length > 0) {
    console.log(projects.length)
        for (const project of projects) {
          let name = project.name
          let owner = null
          if (project.ownedByUser) {
            owner = await this.contract.methods.getUser(project.owner).call()
            } else {
            owner = await this.contract.methods
              .getEnterprise(project.owner)
              .call()
          }
          let balance = project.balance
          const contributorsList = project.contributors
          let contributors = []
          for (const contributorsAdd of contributorsList) {
            const contributor = await this.contract.methods
              .getUser(contributorsAdd)
              .call()
            contributors.push({
              address: contributorsAdd,
              account: {
                username: contributor.username,
                balance: contributor.balance,
                registered: contributor.registered,
              },
            })
          }
          this.projects.push({
            id: project.id,
            name: name,
            owner: {
              name: owner.name || undefined,
              username: owner.username || undefined,
              balance: owner.balance,
            },
            ownerAddress: project.owner,
            ownedByUser: project.ownedByUser,
            balance: balance,
            contributors: contributors,
          })
        }
      }
    }
  },
})
</script>
