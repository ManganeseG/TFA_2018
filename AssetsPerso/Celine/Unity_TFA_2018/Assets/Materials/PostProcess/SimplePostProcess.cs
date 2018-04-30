using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SimplePostProcess : MonoBehaviour
{
    public Material PostProcessMaterial;
    private Camera cam;

    private void Awake()
    {
        cam = GetComponent<Camera>();
    }

    private void OnRenderImage(RenderTexture source, RenderTexture destination) //script pour la caméra, src = copie du framebuff, destination = framebuffer courant
    {
        Shader.SetGlobalMatrix("CameraInvView", cam.worldToCameraMatrix.inverse);
        Graphics.Blit(source, destination, PostProcessMaterial); //rendu du rendertext sur une autre
    }
}
