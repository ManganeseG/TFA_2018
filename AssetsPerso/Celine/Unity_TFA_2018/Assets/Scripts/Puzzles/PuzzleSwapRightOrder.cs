using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PuzzleSwapRightOrder : MonoBehaviour
{
    public List<Material> MaterialArray = new List<Material>();
    public List<Material> PlayerList = new List<Material>();
    public static Material[] PlayerArray = new Material[4];
    // public Material[] SecondTextureArray;
    // public Material[] ThirdTextureArray;

    public KeyCode Activate;

    private int firstChosenMat;
    private int secondChosenMat;
    private int thirdChosenMat;

    public int NumberOfTextureArray;

   // private static Random randomArray = new Random();
    public int NumberOfTextures;

    public GameObject RightOrderPannel;
    public bool changing = true;
   // private bool showNext = false;

    public float CdBetweenEachRenderer = 1f;
    private float cdBetweenEachRenderer;
    private float CdBetweenEachArray = 4f;
    public float cdBetweenEachArray;

    private void Awake()
    {
        Randomize();
        RandomArray(MaterialArray);
    }
    void Start()
    {
        cdBetweenEachRenderer = CdBetweenEachRenderer;
        cdBetweenEachArray = CdBetweenEachArray;
        Collider[] colliders = GetComponentsInChildren<Collider>();

    }

    void Update()
    {
        if (changing)
        {
            cdBetweenEachRenderer -= Time.deltaTime;
            RightOrderPannel.GetComponent<Renderer>().material = MaterialArray[0];
            if (cdBetweenEachRenderer <= 0f)
            {
                RightOrderPannel.GetComponent<Renderer>().material = MaterialArray[1];
                if (cdBetweenEachRenderer <= -2f)
                {
                    RightOrderPannel.GetComponent<Renderer>().material = MaterialArray[2];
                    if (cdBetweenEachRenderer <= -4f)
                    {
                        RightOrderPannel.GetComponent<Renderer>().material = MaterialArray[3];
                        if (cdBetweenEachRenderer <= -6f)
                        {
                            RightOrderPannel.GetComponent<Renderer>().material = MaterialArray[4];
                            if (cdBetweenEachRenderer <= -8f)
                            {
                                cdBetweenEachArray -= Time.deltaTime;
                                if (cdBetweenEachArray <= 0f)
                                    cdBetweenEachRenderer = CdBetweenEachRenderer;
                            }
                        }
                    }
                }
            }
        }

       //if (PlayerList != MaterialArray)
       //{
       //    Debug.Log("PuzzleNotCorrect");
       //}
       //else
       //    Debug.Log("PuzzleCorrect");
    }

    void RandomArray(List<Material> mat)
    {
        for (int i = 0; i < MaterialArray.Count; i++)
        {
            Material tmp = MaterialArray[i];
            int random = Random.Range(i, MaterialArray.Count);
            MaterialArray[i] = MaterialArray[random];
            MaterialArray[random] = tmp;
        }
    }

    private void OnTriggerStay(Collider other)
    {
       //Debug.Log("A");
       //for (int i = 0; i < 2 ; i++)
       //{
       //    if (other.gameObject.layer == LayerMask.NameToLayer("Player") && Input.GetKeyDown(Activate) == true)
       //    {
       //        Debug.Log("Wow triggered");
       //        foreach (GameObject panel in PlaneObj)
       //        {
       //            PlayerArray[i] = GetComponent<Renderer>().material;
       //            Debug.Log(PlayerArray[i]);
       //        }
       //    }
       //}


        
    }


    public void Randomize()
    {

        //
        //  for (int i = 0; i < NumberOfTextureArray; i++)
        //  {
        //      randomInt.Add(i);
        //  }
        //
        //foreach (Material AvailableMat in MaterialArray)
        //{
        //    int j = Random.Range(0, MaterialArray.Length);
        //    switch (j)
        //    {
        //        case 0:
        //            firstChosenMat = Random.Range(0, MaterialArray.Length);
        //            if (firstChosenMat == secondChosenMat || firstChosenMat == thirdChosenMat)
        //            {
        //                firstChosenMat = Random.Range(0, MaterialArray.Length);
        //            
        //            }
        //            RightOrderPannel.GetComponent<Renderer>().material = MaterialArray[firstChosenMat];
        //            break;
        //        case 1:
        //            secondChosenMat = Random.Range(0, MaterialArray.Length);
        //            if (secondChosenMat == firstChosenMat || secondChosenMat == thirdChosenMat)
        //            {
        //                secondChosenMat = Random.Range(0, MaterialArray.Length);
        //
        //            }
        //            RightOrderPannel.GetComponent<Renderer>().material = MaterialArray[secondChosenMat];
        //            break;
        //        case 2:
        //            thirdChosenMat = Random.Range(0, MaterialArray.Length);
        //            if (secondChosenMat == thirdChosenMat || thirdChosenMat == firstChosenMat)
        //            {
        //                thirdChosenMat = Random.Range(0, MaterialArray.Length);
        //
        //            }
        //            RightOrderPannel.GetComponent<Renderer>().material = MaterialArray[thirdChosenMat];
        //            break;
        //    }
        //}

    }
}
