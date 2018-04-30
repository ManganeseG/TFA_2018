using UnityEngine;

[ExecuteInEditMode]
public class PostProcessExample : MonoBehaviour
{
	public Material PostProcessMat;
	Camera cam;

	private void Awake()
	{
		cam = GetComponent<Camera>();
		if( PostProcessMat == null )
			enabled = false;
	}
	
	void OnRenderImage( RenderTexture src, RenderTexture dest )
	{
		Shader.SetGlobalMatrix("CameraWorld", transform.localToWorldMatrix);
		Shader.SetGlobalMatrix("CameraInvView", cam.worldToCameraMatrix.inverse);
		
		Graphics.Blit( src, dest, PostProcessMat );
	}
}
