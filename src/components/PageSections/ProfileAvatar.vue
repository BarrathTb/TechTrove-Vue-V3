<!-- <template>
  <div>
    <VaButton color="custom-success" text="bold" @click="triggerFileSelect" :loading="uploading">
      {{ uploading ? 'Uploading...' : 'Upload' }}
    </VaButton>

    <input
      ref="fileInputRef"
    
      type="file"
      accept="image/*"
      @change="uploadAvatar"
      style="display: none"
      :disabled="uploading"
    />
  </div>
</template>

<script>
import { ref, defineComponent } from 'vue' // Removed unnecessary imports
import { supabase } from '@/utils/Supabase'
import { useUserStore } from '@/stores/User'

export default defineComponent({
  setup(props, { emit }) {
    const uploading = ref(false)
    const files = ref(null)
    const fileInputRef = ref(null)
    const userStore = useUserStore()

    const triggerFileSelect = () => {
      if (fileInputRef.value) {
        fileInputRef.value.click()
      }
    }

    const uploadAvatar = async (evt) => {
      files.value = evt.target.files
      try {
        uploading.value = true
        if (!files.value || files.value.length === 0) {
          throw new Error('You must select an image to upload.')
        }

        const file = files.value[0]
        const fileExt = file.name.split('.').pop()
        const filePath = `${Math.random()}.${fileExt}`

        // Upload the file to Supabase storage
        const { error: uploadError } = await supabase.storage.from('avatars').upload(filePath, file)
        if (uploadError) throw uploadError

        // Retrieve the public URL for the uploaded file
        const { publicURL, error: urlError } = await supabase.storage
          .from('avatars')
          .getPublicUrl(filePath)
        if (urlError) throw urlError

        // Get the current user's ID
        const userId = userStore.user.id

        // Update the avatar URL in the 'profiles' table
        const { error: updateError } = await supabase
          .from('profiles')
          .update({ avatar_url: publicURL })
          .eq('id', userId)

        if (updateError) throw updateError

        // Emit the event with the new avatar URL to update it in the profile
        emit('avatar-uploaded', publicURL)
      } catch (error) {
        alert(error.message)
      } finally {
        uploading.value = false
      }
    }

    return {
      uploading,
      files,
      fileInputRef,
      triggerFileSelect,
      uploadAvatar
    }
  }
})
</script> -->
<template>
  <div>
    <VaButton color="custom-success" text="bold" @click="triggerFileSelect" :loading="uploading">
      {{ uploading ? 'Uploading...' : 'Upload' }}
    </VaButton>

    <input
      ref="fileInputRef"
      type="file"
      accept="image/*"
      @change="uploadAvatar"
      style="display: none"
      :disabled="uploading"
    />
  </div>
</template>

<script>
import { supabase } from '@/utils/Supabase'
import { useUserStore } from '@/stores/User'

export default {
  data() {
    return {
      uploading: false,
      files: null,
      fileInputRef: null
    }
  },
  methods: {
    triggerFileSelect() {
      this.$refs.fileInputRef.click()
    },
    async uploadAvatar(evt) {
      try {
        this.uploading = true
        const files = evt.target.files

        if (!files || files.length === 0) {
          throw new Error('You must select an image to upload.')
        }

        const file = files[0]
        const fileExt = file.name.split('.').pop()
        const filePath = `${Math.random()}.${fileExt}`

        // Upload the file to Supabase storage
        const { error: uploadError } = await supabase.storage.from('avatars').upload(filePath, file)

        if (uploadError) throw uploadError

        // Retrieve the public URL for the uploaded file
        const { data, error: urlError } = await supabase.storage
          .from('avatars')
          .getPublicUrl(filePath)

        if (urlError) throw urlError

        const publicUrl = data.publicUrl

        // Get the current user's ID
        const userStore = useUserStore()
        const userId = userStore.user.id

        // Update the avatar URL in the 'profiles' table
        const { error: updateError } = await supabase
          .from('profiles')
          .update({ avatar_url: publicUrl })
          .eq('id', userId)
          .select()

        if (updateError) throw updateError

        // Emit the event with the new avatar URL to update it in the profile
        this.$emit('avatar-uploaded', publicUrl)
      } catch (error) {
        console.error('Error uploading avatar:', error.message)
        alert(error.message)
      } finally {
        this.uploading = false
      }
    }
  }
}
</script>
