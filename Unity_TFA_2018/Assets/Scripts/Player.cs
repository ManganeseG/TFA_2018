using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Player : MonoBehaviour
{
    public static float Speed = 7.0f;
    public float RotateSpeed = 10.0f;
    public GameObject Bullet;
    public float FireRate = 10.0f;

    private float cooldownTime = 0.0f;

    private static Player current;
    public static Player Current
    {
        get { return current; }
    }
    void Awake()
    {
        current = this;
    }

    public GameObject ArjunaMesh;
    public GameObject ErwinMesh;
    public GameObject TanvirMesh;
    public GameObject AlishaMesh;
    public GameObject TypeAMesh;
    public GameObject MallikaMesh;

    public KeyCode Arjuna;
    public KeyCode Erwin;
    public KeyCode Tanvir;
    public KeyCode Alisha;
    public KeyCode TypeA;
    public KeyCode Mallika;

    private Transform PlayerPosition;

    public enum Characters
    {
        Arjuna,
        Erwin,
        Tanvir,
        Alisha,
        TypeA,
        Mallika
    }
    public Characters ActiveChar = Characters.Arjuna;

    public bool IsActive;


    void Start()
    {
        ArjunaMesh.SetActive(true);
        ErwinMesh.SetActive(true);
        TanvirMesh.SetActive(true);
        AlishaMesh.SetActive(true);
        TypeAMesh.SetActive(true);
        MallikaMesh.SetActive(true);
    }

    void Update()
    {

        ArjunaMesh.transform.position = transform.position;
        ErwinMesh.transform.position = transform.position;
        TanvirMesh.transform.position = transform.position;
        AlishaMesh.transform.position = transform.position;
        TypeAMesh.transform.position = transform.position;
        MallikaMesh.transform.position = transform.position;

 #region Movements
        float x = Input.GetAxis("Horizontal") * Time.deltaTime * RotateSpeed;
        float z = Input.GetAxis("Vertical") * Time.deltaTime * Speed;

        float horizontalFire = Input.GetAxis("Horizontal2");
        float verticalFire = Input.GetAxis("Vertical2");

        float intensity = Mathf.Sqrt(horizontalFire * horizontalFire + verticalFire * verticalFire);

        transform.Rotate(0.0f, x, 0.0f);
        transform.Translate(0.0f, 0.0f, z);
        cooldownTime -= Time.deltaTime;

        if (intensity > 0.5f)
        {
            Quaternion rotationFire = Quaternion.LookRotation(new Vector3(horizontalFire, 0.0f, verticalFire));
            if (cooldownTime <= 0.0f)
            {
                Instantiate(Bullet, transform.localPosition, rotationFire);
                cooldownTime = 1.0f / FireRate;
            }
        }
        #endregion 

        if (Input.GetKey(Arjuna))
            ActiveChar = Characters.Arjuna;
        if (Input.GetKey(Erwin))
            ActiveChar = Characters.Erwin;
        if (Input.GetKey(Tanvir))
            ActiveChar = Characters.Tanvir;
        if (Input.GetKey(Alisha))
            ActiveChar = Characters.Alisha;
        if (Input.GetKey(TypeA))
            ActiveChar = Characters.TypeA;
        if (Input.GetKey(Mallika))
            ActiveChar = Characters.Mallika;

        switch (ActiveChar)
        {
            case Characters.Arjuna:
                ArjunaMesh.SetActive(true);
                ErwinMesh.SetActive(false);
                TanvirMesh.SetActive(false);
                AlishaMesh.SetActive(false);
                TypeAMesh.SetActive(false);
                MallikaMesh.SetActive(false);
                break;
            case Characters.Erwin:
                ArjunaMesh.SetActive(false);
                ErwinMesh.SetActive(true);
                TanvirMesh.SetActive(false);
                AlishaMesh.SetActive(false);
                TypeAMesh.SetActive(false);
                MallikaMesh.SetActive(false);
                break;
            case Characters.Tanvir:
                ArjunaMesh.SetActive(false);
                ErwinMesh.SetActive(false);
                TanvirMesh.SetActive(true);
                AlishaMesh.SetActive(false);
                TypeAMesh.SetActive(false);
                MallikaMesh.SetActive(false);
                break;
            case Characters.Alisha:
                ArjunaMesh.SetActive(false);
                ErwinMesh.SetActive(false);
                TanvirMesh.SetActive(false);
                AlishaMesh.SetActive(true);
                TypeAMesh.SetActive(false);
                MallikaMesh.SetActive(false);
                break;
            case Characters.TypeA:
                ArjunaMesh.SetActive(false);
                ErwinMesh.SetActive(false);
                TanvirMesh.SetActive(false);
                AlishaMesh.SetActive(false);
                TypeAMesh.SetActive(true);
                MallikaMesh.SetActive(false);
                break;
            case Characters.Mallika:
                ArjunaMesh.SetActive(false);
                ErwinMesh.SetActive(false);
                TanvirMesh.SetActive(false);
                AlishaMesh.SetActive(false);
                TypeAMesh.SetActive(false);
                MallikaMesh.SetActive(true);
                break;
            default:
                break;
        }


        // for (int i = 0; i < Characters.Length; i++)
        // {
        //     int _whichChar = NumberOfCharacters[i];
        // }
    }
}
