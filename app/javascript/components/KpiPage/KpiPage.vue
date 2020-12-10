<template>
  <div>

  </div>
</template>

<script>
  import axios from 'axios'
  import { setAxiosHeaders } from '../../helpers/axios-helpers'

  setAxiosHeaders(axios)

  export default {
    name: 'KpiPage',
    props: {
      endpoint: {
        required: true,
        type: String
      },
    }
  }
</script>