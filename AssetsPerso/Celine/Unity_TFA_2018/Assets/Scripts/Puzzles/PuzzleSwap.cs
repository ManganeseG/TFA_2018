using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PuzzleSwap : MonoBehaviour
{
    public Material[] MaterialArray;
    // public Material[] SecondTextureArray;
    // public Material[] ThirdTextureArray;

    private int firstChosenMat;
    private int secondChosenMat;
    private int thirdChosenMat;

    // public int NumberOfTextureArray = 3; 

    public GameObject RightOrderPannel;

    public bool One = false;
    public bool Two = false;
    public bool Three = false;

    public float CdBetweenEachRenderer = 0.5f;
    private float cdBetweenEachRenderer;
    public float CdBetweenEachArray = 2f;
    private float cdBetweenEachArray;


    void Start()
    {
        Randomize();
        cdBetweenEachRenderer = CdBetweenEachRenderer;
        cdBetweenEachArray = CdBetweenEachArray;
    }

    void Update()
    {
        if(One)
            RightOrderPannel.GetComponent<Renderer>().material = MaterialArray[firstChosenMat];
        if(Two)
            RightOrderPannel.GetComponent<Renderer>().material = MaterialArray[secondChosenMat];
        if(Three)
            RightOrderPannel.GetComponent<Renderer>().material = MaterialArray[thirdChosenMat];
    }   

    public void Randomize()
    {
     //
     //  for (int i = 0; i < NumberOfTextureArray; i++)
     //  {
     //      randomInt.Add(i);
     //  }
     //
        foreach(Material AvailableMat in MaterialArray)
        {
            int j = Random.Range(0, MaterialArray.Length);
            switch (j)
            {
                case 0:
                    firstChosenMat = Random.Range(0, MaterialArray.Length);
                    if(firstChosenMat == secondChosenMat || thirdChosenMat == firstChosenMat)
                    {
                        firstChosenMat = Random.Range(0, MaterialArray.Length);
                        
                    }
                    RightOrderPannel.GetComponent<Renderer>().material = MaterialArray[firstChosenMat];
                    break;
                case 1:
                    secondChosenMat = Random.Range(0, MaterialArray.Length);
                    if (firstChosenMat == secondChosenMat || secondChosenMat == thirdChosenMat)
                    {
                        secondChosenMat = Random.Range(0, MaterialArray.Length);
                        
                    }
                    RightOrderPannel.GetComponent<Renderer>().material = MaterialArray[secondChosenMat];
                    break;
                case 2:
                    thirdChosenMat = Random.Range(0, MaterialArray.Length);
                    if(secondChosenMat == thirdChosenMat || thirdChosenMat == firstChosenMat)
                    {
                        thirdChosenMat = Random.Range(0, MaterialArray.Length);
                        
                    }
                    RightOrderPannel.GetComponent<Renderer>().material = MaterialArray[thirdChosenMat];
                    break;
            }
        }
       
    }
}
